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
    name      "University of North Carolina"
    location  "Chapel Hill, NC"

    factory :second_school do
      name      "University of Georgia"
      location  "Athens, GA"
    end

    factory :invalid_school do
      name nil
      location nil
    end
  end
end

