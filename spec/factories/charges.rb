# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  amount           :float
#  axon_fee         :float
#  tutor_fee        :float
#  tutor_id         :integer
#  token            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  promotion_id     :integer
#  student_id       :integer
#  stripe_charge_id :string
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
