# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  school_id          :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  rating             :integer
#  degree             :integer          default(0)
#  major              :string
#  additional_degrees :string
#  extra_info_1       :text
#  extra_info_2       :text
#  extra_info_3       :text
#  graduation_year    :string
#  phone_number       :string
#  birthdate          :date
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  courses_approved   :boolean          default(FALSE)
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

  delegate :first_name, :last_name, :full_name, :sign_in_ip, :email, :password, :slug, to: :user

  enum application_status: ['Incomplete', 'Complete', 'Approved']
  enum active_status: ['Inactive', 'Active']
  enum degree: ["B.A.","B.S.","M.B.A.","M.S.","M.Ed.","PhD."]
  enum onboarding_status: ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Finished']

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_create :change_user_role_to_tutor
  after_commit :update_application_status

  # custom validation - prevents a tutor from changing school if tutor has courses at one school
  def school_change_allowed?
    self.courses.count > 0 ? false : true
  end

  def self.degree_collection
    ["B.A.","B.S.","M.B.A.","M.S.","M.Ed.","PhD."]
  end

  def crop_profile_pic(tutor_params)
    profile_pic.recreate_versions! if tutor_params[:crop_x]
    profile_pic.delete_cache_id
  end

  def sign_up_date
    self.created_at.to_date
  end

  def formatted_courses
    self.courses.map{ |course| course.formatted_name}.join("<br>").html_safe()
  end

  def active?
    self.active_status == 'Active' ? true : false
  end

  def complete_application?
    fields = [:profile_pic, :transcript, :profile_info]
    fields.each do |field|
      if account_has?(field) == false then return false end
    end
    true
  end

  def account_has?(field)
    case field
    when :profile_pic
      self.profile_pic.url == 'panda.png' ? false : true
    when :transcript
      self.transcript.url == nil ? false : true
    when :profile_info
      (self.degree.present? && self.major.present? && self.extra_info_1.present? && self.graduation_year.present?) ? true : false
    end
  end

  def complete_payment_info_details?
    (self.line1 && self.line2 && self.city && self.state && self.postal_code && self.acct_id && self.last_4_acct && self.ssn_last_4) ? true : false
  end

  def awaiting_approval?
    self.application_status == 'Complete' ? true : false
  end

  def zero_availability_set?
    self.incomplete_profile? == false && 
    self.awaiting_approval? == false && 
    self.slots.count == 0 ? 
    true : false
  end

  def onboarding_complete?
    self.complete_application? && 
    self.application_status == 'Approved' && 
    self.courses_approved? &&
    self.slots.count > 0 &&
    self.acct_id ? 
    true : false 
  end

  def send_active_status_change_email(tutor_params)
    if tutor_params[:active_status] == 'Active'
      TutorManagementMailer.delay.activation_email(self.user.id)
    end
    if tutor_params[:active_status] == 'Inactive'
      TutorManagementMailer.delay.deactivation_email(self.user.id)
    end
  end

  def get_slots_in_date_range(start_date, end_date)
    self.slots.select{|slot| slot.start_time.to_date >= start_date.to_date && slot.start_time.to_date <= end_date.to_date }
  end

  def update_action_redirect_path(tutor_params)
    if tutor_params[:birthdate] || tutor_params[:phone_number] || tutor_params[:transcript]
      "/tutors/#{self.user.slug}/settings/account"
    elsif tutor_params[:appt_notes]
      "/tutors/#{self.user.slug}/settings/appointment_settings"
    elsif tutor_params[:line1] || tutor_params[:city] || tutor_params[:state] || tutor_params [:postal_code]
      "/tutors/#{self.user.slug}/settings/payment_info"
    elsif tutor_params[:courses_approved]
      "/tutors/#{self.user.slug}/courses"
    else
      "/tutors/#{self.user.slug}/settings/edit_profile"
    end
  end

  def change_user_role_to_tutor
    # method called in after_create hook to automatically change the default role of student to tutor
    if self.user.role == 'student'
      self.user.update(role: 'tutor')
    end
  end

  def update_application_status
    # method called in after_commit hook to automatically update a tutor's application status and send application_completed email
    if self.complete_application? && self.application_status == 'Incomplete'
      self.update(application_status: 'Complete')
      TutorManagementMailer.delay.application_completed_email(self.user.id)
    end
  end

  def self.applications_awaiting_approval(user) # get user to determine admin level
    if user.role == 'campus_manager' # campus-mangers only see applications at their school
      user.school.tutors.where(application_status: 1, active_status: 0)
    else # super-admin can see all applications across all schools
      Tutor.where(application_status: 1, active_status: 0)
    end
  end

  def appointments_with_times_only_for_public_scheduler
    # returns limited information about a tutor's appointments for public API call for scheduler
    self.appointments.map{ |appt| {id: appt.id, start_time: appt.start_time, status: appt.status}}
  end

  def restricted_appointments_info(tutor, current_user)
    # returns all appointment details (including student_id) for logged-in tutor that owns appointment, returns only necessary details for scheduler for all others (only: id, start_time, status)
    if current_user && current_user.tutor == self
      @appointments = self.appointments
    else
      @appointments = self.appointments_with_times_only_for_public_scheduler
    end
  end

  def total_income
    self.charges.map(&:tutor_fee).reduce(:+) || 0
  end

  def course_list
    self.tutor_courses.map do |tc|
      tutor_course_info = {}
      tutor_course_info[:id] = tc.id
      tutor_course_info[:course_id] = tc.course.id
      tutor_course_info[:course_name] = tc.course.friendly_name
      tutor_course_info[:rate] = tc.rate
      tutor_course_info
    end
  end

  # def onboarding_step 
  #   step_number = 1
  #   self.application_status == 'Complete' ? (step_number += 1) : (return step_number)
  #   self.courses_approved? ? (step_number += 1) : (return step_number)
  #   self.slots.count > 0 ? (step_number += 1) : (return step_number)
  #   !self.acct_id.nil? ? (step_number += 1) : (return step_number)
  #   step_number
  # end

end