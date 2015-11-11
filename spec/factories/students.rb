# == Schema Information
#
# Table name: students
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  school_id     :integer
#  phone_number  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :string
#  last_4_digits :string
#  card_brand    :string
#

FactoryGirl.define do
  factory :student do
    user

    trait :alternate do 
      association :user, factory: :alternate_user
    end
    
  end

end
