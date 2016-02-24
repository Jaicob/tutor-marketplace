# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  school_id          :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  approval           :integer
#  degree             :integer          default(0)
#  major              :string
#  additional_degrees :string
#  extra_info_1       :text
#  extra_info_2       :text
#  extra_info_3       :text
#  graduation_year    :string
#  phone_number       :string
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  onboarding_status  :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  last_4_acct        :string
#  line1              :string
#  line2              :string
#  city               :string
#  state              :string
#  postal_code        :string
#  ssn_last_4         :string
#  acct_id            :string
#  slug               :string
#  dob                :date
#  booking_buffer     :integer          default(6)
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :promotions

  delegate :first_name, :last_name, :full_name, :public_name, :sign_in_ip, :email, :password, to: :user

  validates :user, presence: true

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  enum application_status: ['Incomplete', 'Complete', 'Approved']
  enum active_status: ['Inactive', 'Active']
  enum degree: ["B.A.","B.S.","M.B.A.","M.S.","M.Ed.","PhD."]
  # onboarding_status key = 'Step 1', 'Step 2', 'Step 3', 'Step 4', 'Finished'

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_commit :update_application_status
  after_create :change_default_user_role_to_tutor

  # variations of a user's name to create unique slugs in case of duplicate names
  def slug_candidates
    [ "#{first_name}#{last_name}", "#{first_name[0]}#{last_name}", "#{first_name}#{last_name[0]}", "#{first_name[0..1]}#{last_name}", "#{first_name}#{last_name[0..1]}", "#{first_name[0..2]}#{last_name}", "#{first_name}#{last_name[0..2]}", "#{first_name[0..3]}#{last_name}", "#{first_name}#{last_name[0..3]}"]
  end

  # default user role is student so this method is called in after_create hook to automatically change user.role to tutor
  def change_default_user_role_to_tutor
    if self.user.role == 'student'
      self.user.update(role: 'tutor')
    end
  end

  # validation method used in controllers - prevents a tutor from changing school if tutor has courses at one school
  def school_change_allowed?
    self.courses.count > 0 ? false : true
  end

  # helper method for views
  def first_and_last_initial
    self.first_name + " " + self.last_name.slice(0) + "."
  end

  # degrees to be displayed in degree select dropdown for tutors
  def self.degree_collection
    ["B.A.","B.S.","M.B.A.","M.S.","M.Ed.","PhD."]
  end

  # called in update action of tutors_controller to re-create thumbnail of profile pic if :crop_x attribute is present in params
  def crop_profile_pic(tutor_params)
    profile_pic.recreate_versions! if tutor_params[:crop_x]
    profile_pic.delete_cache_id
  end

  # method called in after_commit hook to automatically update a tutor's application status and send application_completed email
  def update_application_status
    if (self.onboarding_status == 4) && (self.acct_id != nil) && (self.application_status == 'Incomplete')
      self.update(application_status: 'Complete')
      TutorManagementMailer.delay.application_completed_email(self.user.id)
    end
  end

  def reviews
    reviews = []
    self.appointments.each do |appt|
      reviews << appt.review if !appt.review.nil?
    end
    return reviews
  end

  # method for Admin section, to show what an incomplete Tutor account is missing
  def missing_application_fields
    missing_fields = []
    fields = ['degree','major','extra_info_1','extra_info_2','extra_info_3','graduation_year','phone_number','profile_pic','transcript','last_4_acct','line1','city','state','postal_code','ssn_last_4','acct_id','dob']
    profile_fields = ['degree','major','extra_info_1','extra_info_2','extra_info_3','graduation_year']
    address_fields = ['line1','city','state','postal_code','ssn_last_4']
    bank_acct_fields = ['acct_id','last_4_acct']
    fields.each do |field|
      if self.send(field).blank?
        if profile_fields.include?(field)
          missing_fields << 'Profile Needs Completion (See Preview Below)'
        elsif address_fields.include?(field)
          missing_fields << 'Address Missing'
        elsif bank_acct_fields.include?(field)
          missing_fields << 'Bank Account Not Connected'
        elsif field == 'phone_number'
          missing_fields << 'Phone Number Missing'
        elsif field == 'profile_pic'
          missing_fields << 'Profile Picture Missing'
        elsif field == 'transcript'
          missing_fields << 'Transcript Missing'
        elsif field == 'dob'
          missing_fields << "DOB Missing"
        end
      end
    end
    return missing_fields.uniq{|x| x}
  end

  # method for admin section - admin user taken as argument to determine whether or not to list tutors from all schools or just one school depending on if its a campus manager or regular admin
  def self.applications_awaiting_approval(user) # get user to determine admin level
    if user.role == 'campus_manager' # campus-mangers only see applications at their school
      user.school.tutors.where(application_status: 1, active_status: 0)
    else # super-admin can see all applications across all schools
      Tutor.where(application_status: 1, active_status: 0)
    end
  end

  # called in update action in Dashboard::Admin::TutorsController to trigger activation/deactivation email if :active_status param is present
  def send_active_status_change_email(tutor_params)
    if tutor_params[:active_status] == 'Active'
      TutorManagementMailer.delay.activation_email(self.user.id)
    end
    if tutor_params[:active_status] == 'Inactive'
      TutorManagementMailer.delay.deactivation_email(self.user.id)
    end
  end

  # called in every post action of the tutor_onboarding controller to update status in onboarding process
  def update_onboarding_status(step_completed)
    if step_completed > self.onboarding_status
      self.update(onboarding_status: step_completed)
    end
  end

  # returns limited information about a tutor's appointments for public API call for scheduler
  def appointments_with_times_only_for_public_scheduler
    self.appointments.map{ |appt| {id: appt.id, start_time: appt.start_time, status: appt.status}}
  end

  # returns all appointment details (including student_id) for logged-in tutor that owns appointment, returns only necessary details for scheduler for all others (only: id, start_time, status)
  def restricted_appointments_info(tutor, current_user)
    if current_user && current_user.tutor == self
      @appointments = self.appointments
    else
      @appointments = self.appointments_with_times_only_for_public_scheduler
    end
  end

  # helper method to format data for API controller for React Checkout
  def course_list
    self.tutor_courses.map do |tc|
      tutor_course_info = {}
      tutor_course_info[:id] = tc.id
      tutor_course_info[:course_id] = tc.course.id
      tutor_course_info[:course_number] = tc.course.subject.name + " " + tc.course.call_number
      tutor_course_info[:course_name] = tc.course.friendly_name
      tutor_course_info[:rate] = tc.rate
      tutor_course_info
    end
  end

  def course_list_by_subject
    data = {}
    self.tutor_courses.each do |tc|
      unless data.has_key?(tc.course.subject.name)
        data[tc.course.subject.name] = []
      end
      tc_info = {
        id: tc.id,
        course_id: tc.course.id,
        short_name: tc.course.subject.name + " " + tc.course.call_number,
        friendly_name: tc.course.friendly_name,
        rate: tc.rate
      }
      data[tc.course.subject.name] << tc_info
    end
    return data
  end

  def get_slots_in_date_range(start_date, end_date)
    self.slots.select{|slot| slot.start_time.to_date >= start_date.to_date && slot.start_time.to_date <= end_date.to_date }
  end

  # used to redirect to the correct page based on different attributes being updated through the tutors_controller
  def update_action_redirect_path(tutor_params)
    if tutor_params[:birthdate] || tutor_params[:phone_number] || tutor_params[:transcript]
      "/tutors/#{self.slug}/settings/account"
    elsif tutor_params[:appt_notes]
      "/tutors/#{self.slug}/settings/appointment_settings"
    elsif tutor_params[:line1] || tutor_params[:city] || tutor_params[:state] || tutor_params [:postal_code]
      "/tutors/#{self.slug}/settings/payment_info"
    elsif tutor_params[:courses_approved]
      "/tutors/#{self.slug}/courses"
    else
      "/tutors/#{self.slug}/settings/edit_profile"
    end
  end

end
