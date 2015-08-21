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
#  appt_notes         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_many :appointments, through: :slots, dependent: :destroy

  delegate :school, :full_name, :email, to: :user

  enum application_status: ['Incomplete', 'Complete', 'Approved']
  enum active_status: ['Inactive', 'Active']

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  validates :transcript, presence: true
  validates :extra_info, presence: true

  # Neccessary to create a tutor's first tutor_course during sign-up process
  # All subsequent tutor_courses will be added normally through the tutor_courses_controller
  def set_first_tutor_course(tutor, params)
    course_id = params[:course][:course_id]
    rate = params[:tutor_course][:rate]
    tutor.tutor_courses.create(tutor_id: tutor.id, course_id: course_id, rate: rate)
  end

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
    courses = []
    self.courses.each do |course|
      courses << [course.formatted_name]
    end
    courses.join("<br>").html_safe()
  end

  def availability_booked_percent
  end

  def get_slots_in_date_range(start_date, end_date)
    self.slots.select{|slot| slot.start_time.to_date > start_date.to_date && slot.start_time.to_date < end_date.to_date }
  end

end
