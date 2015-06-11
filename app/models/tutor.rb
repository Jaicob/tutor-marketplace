# == Schema Information
#
# Table name: tutors
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  rating                  :integer
#  status                  :integer          default(0)
#  birthdate               :date
#  degree                  :string
#  major                   :string
#  extra_info              :string
#  graduation_year         :string
#  phone_number            :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  transcript_file_name    :string
#  transcript_content_type :string
#  transcript_file_size    :integer
#  transcript_updated_at   :datetime
#  profile_pic             :string
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  enum status: [:applied, :awaiting_approval, :approved]

  # Carrierwave setup for uploading a profile pic
  mount_uploader :profile_pic, ProfilePicUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  # Paperclip setup for uploading a transcript
  
  validates :extra_info, presence: true
  # Cannot add validations for other attributes because Tutor sign-up form creates Tutor before they are asked for. We should create a method that checks if a tutor profile is complete before allowing them to access some functionalities (what is required for a tutor to start working and taking appointments?)

  def set_first_tutor_course(tutor, params)
    course_id = params[:course][:course_id]
    rate = params[:tutor_course][:rate]
    tutor.tutor_courses.create(tutor_id: tutor.id, course_id: course_id, rate: rate)
  end

  def crop_profile_pic
    profile_pic.recreate_versions! if crop_x.present?
  end


end

