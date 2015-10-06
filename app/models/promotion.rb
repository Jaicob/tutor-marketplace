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
#  tutor_id         :integer
#  course_id        :integer
#

class Promotion < ActiveRecord::Base
  validates :amount, presence: :true

  belongs_to :tutor # or if tutor_id is blank, is an Axon HQ coupon

  after_create :generate_secure_code

  enum category: [
    :free_from_axon, 
    :free_from_tutor, 
    :percent_off_from_axon, 
    :percent_off_from_tutor, 
    :dollar_amount_off_from_axon, 
    :dollar_amount_off_from_tutor, 
    :repeating_percent_off_from_tutor, 
    :repeating_dollar_amount_off_from_tutor]

  def generate_secure_code
    puts "CATEGORY = #{self.category}"
    promo_category = self.category
    case self.category
    when 'free_from_axon'
      prefix = 'AXONFREE'
    when 'free_from_tutor'
      prefix = 'TUTORFREE'
    when 'percent_off_from_axon'
      prefix = 'AXONPER'
    when 'percent_off_from_tutor'
      prefix = 'TUTORPER'
    when 'dollar_amount_off_from_axon'
      prefix = 'AXONDLR'
    when 'dollar_amount_off_from_tutor'
      prefix = 'TUTORDLR'
    when 'repeating_percent_off_from_tutor'
      prefix = 'TUTORPKPER'
    when 'repeating_dollar_amount_off_from_tutor'
      prefix = 'TUTORPKDLR'
    end
    self.code = prefix + SecureRandom.hex(6)
    self.save
  end

end