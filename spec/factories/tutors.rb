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

FactoryGirl.define do
  factory :tutor do
    extra_info "Student Research Assistant for Biology Department"
    transcript Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/factories/files/transcript.doc')))

      factory :invalid_tutor do
        extra_info nil
      end
  
      factory :complete_tutor do
        user
        rating 1
        active_status 0
        application_status 0
        birthdate "1992-05-28"
        degree "B.A."
        major "Biology"
        graduation_year "2019"
        phone_number "555-555-5555"
        profile_pic Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/factories/files/profile_pic.jpg')))
      end

      factory :second_complete_tutor do 
        user
        rating 1
        active_status 0
        birthdate '1995-05-10'
        degree 'B.A.'
        major 'Chemistry'
        graduation_year '2017'
        phone_number '999-999-9999'
      end
  end
end
