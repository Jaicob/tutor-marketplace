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
    code 'TestPromo'
    category 'Free'
    amount 10
    valid_from "2015-09-21"
    valid_until "2020-01-01"
    redemption_limit 100
    redemption_count 0
  end

end
