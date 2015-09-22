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

class Charge < ActiveRecord::Base
  belongs_to :tutor
  has_many :appointments
  has_one :promotion

end
