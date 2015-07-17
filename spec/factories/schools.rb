# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do

  sequence(:name) { |n| "University #{n}"}

  factory :school do
    name
    location  "Athens, GA"

    trait :invalid do
      name nil
    end

    trait :UNC do 
      name "University of North Carolina"
      location "Chapel Hill, NC"
    end

    factory :school_with_two_courses do 
      after(:create) do |school|
        create_list(:course, 2, school: school)
      end
    end

    factory :school_with_bio_courses do 
      after(:create) do |school|
        create_list(:course, 2, school: school, subject: 'biology')
      end
    end
  end
end

