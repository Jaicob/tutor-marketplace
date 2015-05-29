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
  factory :school do
    name "University of North Carolina"
    location "Chapel Hill, NC"

    trait :second_school do
      name "University of Georgia"
      location "Athens, GA"
    end 
  
  end
end

