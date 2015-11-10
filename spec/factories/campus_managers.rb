# == Schema Information
#
# Table name: campus_managers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  profile_pic  :string
#  phone_number :string
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :campus_manager do
    
  end

end
