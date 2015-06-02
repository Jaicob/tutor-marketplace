# == Schema Information
#
# Table name: tutors
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  rating                  :integer
#  status                  :integer
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
#

class Tutor < ActiveRecord::Base
  belongs_to :user
  has_many :tutor_courses, dependent: :destroy
  has_many :courses, through: :tutor_courses, dependent: :destroy

  has_attached_file :transcript, styles: { small: "64x64", med: "100x100", large: "200x200" }

  validates_attachment :transcript, 
    :presence => true,
    :content_type => { :content_type => [
      "image/jpeg", "image/jpg", "image/gif", "image/png", "application/pdf", 
      "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ] },
    :size => { :in => 0..20.megabytes }


end
