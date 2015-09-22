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

class Promotion < ActiveRecord::Base
  validates :code, presence: true, uniqueness: :true
  validates :amount, presence: :true

  enum category: ['Free', 'Percent Off', 'Dollar Amount Off', 'Semester Package']
end


# A promotion may have many applications.
# A coupon is applied to a charge.
# Some coupon codes can be applied to many different charges. (generic free session by Axon, semeseter package code)

# We want to be able to track a coupon.
# A coupon is simply a promotions code.



