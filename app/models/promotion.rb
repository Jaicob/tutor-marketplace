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
  belongs_to :tutor # or if tutor_id is blank, is an Axon HQ coupon

  validates :redemption_limit, presence: true
  validates :valid_from, presence: true
  validates :valid_until, presence: true
  validates :category, presence: true

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
    when 'free_from_axon' # 0
      prefix = 'AXONFREE'
    when 'free_from_tutor' # 1
      prefix = 'TUTORFREE'
    when 'percent_off_from_axon' # 2
      prefix = 'AXONPER'
    when 'percent_off_from_tutor' # 3
      prefix = 'TUTORPER'
    when 'dollar_amount_off_from_axon' # 4
      prefix = 'AXONDLR'
    when 'dollar_amount_off_from_tutor' # 5
      prefix = 'TUTORDLR'
    when 'repeating_percent_off_from_tutor' # 6
      prefix = 'TUTORPACKPER'
    when 'repeating_dollar_amount_off_from_tutor' # 7
      prefix = 'TUTORPACKDLR'
    end
    self.code = prefix + SecureRandom.hex(6)
    self.save
  end

  def is_valid?(tutor_id)
    if self.category.humanize.split().include?('tutor') # true if tutor-issued promo code
      if (tutor_id == nil) || (self.tutor_id != tutor_id.to_i)
        return false
      end
    end


    return self.redemption_count < self.redemption_limit &&
           self.valid_from.to_date <= Date.today &&
           Date.today <= self.valid_until.to_date
  end

end