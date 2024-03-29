# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  amount           :integer
#  axon_fee         :integer
#  tutor_fee        :integer
#  tutor_id         :integer
#  token            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  promotion_id     :integer
#  student_id       :integer
#  stripe_charge_id :string
#

class Charge < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student
  has_many :appointments, dependent: :destroy
  has_one :promotion
end