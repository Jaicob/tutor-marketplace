# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  category         :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer          default(0)
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Promotion < ActiveRecord::Base
  validates :code, presence: true, uniqueness: :true
  validates :amount, presence: :true

  enum category: [:free_from_axon, :free_from_tutor, :percent_off, :dollar_amount_off, :semester_package]

  # EXPLANATION OF AMOUNT FOR EACH PROMO TYPE
  # free_from_axon: nil
  # free_from_tutor: nil
  # percent_off: integer representing percentage off (15 = 15% off, etc.)
  # dollar_off_amount: integer representing dollar_amount off (15 = 15 dollars off)
  # semester_package: integer representing the amount of sessions in a package

end


# Promotion.create(code: 'AXON', category: 4, amount: 10, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 100, description: 'promo session 1')
