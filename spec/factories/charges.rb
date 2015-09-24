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
    amount        2000
    axon_fee      300
    tutor_fee     200
    customer_id   1
    tutor
    token         nil
  end

end
