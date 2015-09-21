# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  type             :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :promotion do
    code "MyString"
type 1
amount 1
valid_from "2015-09-21"
valid_until "2015-09-21"
redemption_limit 1
redemption_count 1
  end

end
