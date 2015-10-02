# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  rating             :integer
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  birthdate          :date
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line1              :string
#  line2              :string
#  city               :string
#  state              :string
#  postal_code        :string
#  ssn_last_4         :string
#  acct_id            :string
#  last_4_acct        :string
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :promotions

  delegate :school, :first_name, :last_name, :full_name, :sign_in_ip, :email, :password, to: :user

  enum application_status: ['Incomplete', 'Complete', 'Approved']
  enum active_status: ['Inactive', 'Active']

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_create :change_user_role_to_tutor
  after_commit :update_application_status

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

  def incomplete_profile?
    fields = [:profile_pic, :transcript, :public_info, :private_info, :payment_info, :appt_settings]
    fields.each do |field|
      if check_profile_for(field) == false then return true end
    end
    false
  end

  def complete_profile?
    self.incomplete_profile? ? false : true
  end

  def complete_payment_info_details?
    # need to add back in last_4_ssn
    (self.line1 && self.line2 && self.city && self.state && self.postal_code && self.acct_id && self.last_4_acct && self.ssn_last_4) ? true : false
  end

  def awaiting_approval?
    (self.incomplete_profile? == false && self.active_status == 'Inactive') ? true : false
  end

  def zero_availability_set?
    (self.incomplete_profile? == false && self.awaiting_approval? == false && self.slots.count == 0) ? true : false
  end

  def check_profile_for(field)
    case field
    when :profile_pic
      self.profile_pic.url == 'panda.png' ? false : true
    when :transcript
      self.transcript.url == nil ? false : true
    when :public_info
      (self.degree.present? && self.major.present? && self.extra_info.present? && self.graduation_year.present?) ? true : false
    when :private_info
      (self.birthdate.present? && self.phone_number.present?) ? true : false
    when :payment_info
      self.complete_payment_info_details? ? true : false
    when :appt_settings
      self.appt_notes.present? ? true : false
    end
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
      "/#{self.user.slug}/dashboard/settings/private_information"
    elsif tutor_params[:appt_notes]
      "/#{self.user.slug}/dashboard/settings/appointment_settings"
    elsif tutor_params[:line1] || tutor_params[:city] || tutor_params[:state] || tutor_params [:postal_code]
      "/#{self.user.slug}/dashboard/settings/tutor_payment_settings"
    else
      "/#{self.user.slug}/dashboard/settings/profile_settings"
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
    if self.complete_profile? && self.application_status == 'Incomplete'
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
      return tutor_course_info
    end
  end

end
