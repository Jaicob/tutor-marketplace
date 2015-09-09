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
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots, dependent: :destroy

  delegate :school, :full_name, :email, :password, to: :user

  enum application_status: ['Incomplete', 'Complete', 'Approved']
  enum active_status: ['Inactive', 'Active']

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  validates :extra_info, presence: true
  validates :phone_number, presence: true

  after_create :change_user_role_to_tutor
  after_commit :update_application_status

  def crop_profile_pic(tutor_params)
    profile_pic.recreate_versions! if tutor_params[:crop_x]
  end

  def self.to_csv
    attributes = %w{name email phone_number active_status rating application_status degree major graduation_year birthdate sign_up_date}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def sign_up_date
    self.created_at.to_date
  end

  def formatted_courses
    self.courses.map{ |course| course.formatted_name}.join("<br>").html_safe()
  end

  def availability_booked_percent
    # this method should calculate how many hours of a tutor's availability are actually booked possibly useful for identifying 'super-tutors' should probably only calculate percentages for past availability/appointments, since most bookings are only completed 2 days in advance. also, don't want a tutor with more future set availability (a good thing) to have a lower percentage than someone with less future availability
  end

  def active?
    self.active_status == 'Active' ? true : false
  end

  def incomplete_profile?
    (self.birthdate && self.degree && self.major && self.extra_info && self.graduation_year && self.phone_number && self.profile_pic.url != 'panda.png' && self.transcript.url) ? false : true
  end

  def complete_profile?
    self.incomplete_profile? ? false : true
  end

  def awaiting_approval?
    (self.incomplete_profile? == false && self.active_status == 'Inactive') ? true : false
  end

  def zero_availability_set?
    (self.incomplete_profile? == false && self.awaiting_approval? == false && self.slots.count == 0) ? true : false
  end

  def profile_check(attribute)
    if attribute == :profile_pic
      self.profile_pic.url == 'panda.png' ? false : true
    elsif attribute == :transcript
      self.transcript.url == nil ? false : true
    elsif attribute == :public_info
      (self.degree && self.major && self.extra_info && self.graduation_year) ? true : false
    elsif attribute == :private_info
      (self.birthdate && self.phone_number) ? true : false
    elsif attribute == :payment_info
      false # need to change, but waiting on payment fields to be added to model
    else
      self.public_send(attribute) ? true : false
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
    (tutor_params[:birthdate] || tutor_params[:phone_number]) ? "/#{self.user.slug}/dashboard/settings/private_information" : "/#{self.user.slug}/dashboard/settings/profile_settings"
  end

  def change_user_role_to_tutor
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

end
