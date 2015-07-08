# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  rating             :integer
#  application_status :integer          default(0)
#  birthdate          :date
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  profile_pic        :string
#  transcript         :string
#  active_status      :integer          default(0)
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy
  
  enum application_status: ['Applied', 'Awaiting Approval', 'Approved']
  enum active_status: ['Inactive', 'Active']

  # Carrierwave setup for uploading files
  mount_uploader :profile_pic, ProfilePicUploader
  mount_uploader :transcript, TranscriptUploader

  # Dimensions for cropping profile pics
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  # validates :transcript, presence: true
  validates :extra_info, presence: true
  # Cannot add validations for other attributes because Tutor sign-up form creates Tutor before they are asked for. We should create a method that checks if a tutor profile is complete before allowing them to access some functionalities (what is required for a tutor to start working and taking appointments?)

  def set_first_tutor_course(tutor, params)
    course_id = params[:course][:course_id]
    rate = params[:tutor_course][:rate]
    tutor.tutor_courses.create(tutor_id: tutor.id, course_id: course_id, rate: rate)
  end

  def crop_profile_pic(tutor_params)
    profile_pic.recreate_versions! if tutor_params[:crop_x]
  end

  def schools
    schools = []
    self.courses.each do |course|
      schools << course.school_name unless schools.include?(course.school_name)
    end
    schools
  end

  def application_status
    # This method overrides the built-in attribute method. It returns 'Awaiting Approval' only if all fields have been completed, otherwise it returns "Applied"
    if self.birthdate && self.degree && self.major && self.extra_info && self.graduation_year && self.phone_number && self.profile_pic.url != 'panda.png' && self.transcript.url
      'Awaiting Approval'
    else
      'Applied'
    end
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

  def name
    self.user.full_name
  end

  def email
    self.user.email
  end

  def sign_up_date
    self.created_at.to_date
  end

  # # This method changes the redirect_path for the tutors#update, based on the current user. If the current_user is the same as the tutor, then the redirect points to their profile. If the current user is an Admin activating/de-activating a tutor, then the redirect points back to the Admin tutors index.
  # def redirect_path
  #   if self.user.admin?
  #     ':back'
  #   else
  #     'dashboard_profile_user_path(user)'
  #   end
  # end

  # # This method makes sure that the correct tutor object is being handled whether a tutor is modifying their profile or whether an admin is updating a tutor's active_status or application_status
  # def verify_tutor(tutor_id, params)
  #   if params[:id] == tutor_id
  #     tutor_id
  #   else
  #     params[:id]
  #   end
  # end

end
