# == Schema Information
#
# Table name: charges
#
#  id              :integer          not null, primary key
#  amount          :integer
#  transaction_fee :integer
#  customer_id     :string
#  tutor_id        :integer
#  token           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :charge do
    amount 1
transaction_fee 1
customer_id "MyString"
tutor nil
token "MyString"
  end

end
