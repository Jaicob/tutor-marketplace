# == Schema Information
#
# Table name: schools
#
#  id                     :integer          not null, primary key
#  name                   :string
#  location               :string
#  campus_pic             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#  transaction_percentage :float
#  timezone               :string
#

FactoryGirl.define do

  factory :school do
    name  "University of Georgia"
    location  "Athens, GA"
    transaction_percentage 15
    timezone "Eastern Time (US & Canada)"

    trait :invalid do
      name nil
    end

    trait :UNC do
      name "University of North Carolina"
      location "Chapel Hill, NC"
    end

    trait :with_chem_courses do
      after(:create) do |school|
        create_list(:course, 2, school: school)
      end
    end

    trait :with_bio_courses do
      after(:create) do |school|
        create_list(:course, 2, school: school, subject: {name: 'Biology', id: 0})
      end
    end

    trait :with_two_subjects do
      after(:create) do |school|
        create(:course, school: school, subject: FactoryGirl.create(:subject) )
        create(:course, school: school, subject: FactoryGirl.create(:subject, :Chem) )
      end
    end
  end
end

