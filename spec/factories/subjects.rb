# == Schema Information
#
# Table name: subjects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  
  factory :subject do
    name "CHEM"

    factory :second_subject do 
      name "MATH"
    end

    factory :invalid_subject do
      name nil
    end
  end
end
