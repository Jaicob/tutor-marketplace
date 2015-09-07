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
    name 'Math'

    trait :Chem do 
      name "Chemistry"
    end
  end

end
