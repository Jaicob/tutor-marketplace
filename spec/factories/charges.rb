# == Schema Information
#
# Table name: charges
#
#  id           :integer          not null, primary key
#  amount       :integer
#  axon_fee     :integer
#  tutor_fee    :integer
#  customer_id  :string
#  tutor_id     :integer
#  token        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  promotion_id :integer
#

FactoryGirl.define do
  factory :charge do
    amount        1
    axon_fee      3
    tutor_fee     20
    customer_id   1
    tutor         1
    token         nil
  end

end
