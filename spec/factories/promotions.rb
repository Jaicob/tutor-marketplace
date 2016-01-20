# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  issuer           :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer          default(0)
#  description      :text
#  tutor_id         :integer
#  course_id        :integer
#  single_use       :integer          default(0)
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
    tutor
    course_id 1
  end

end
