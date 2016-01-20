# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  issuer           :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer          default(0)
#  description      :text
#  tutor_id         :integer
#  course_id        :integer
#  single_use       :integer          default(0)
#

class Promotion < ActiveRecord::Base
  belongs_to :tutor # or if tutor_id is blank, is an Axon HQ coupon

  validates :redemption_limit, presence: true
  validates :valid_from, presence: true
  validates :valid_until, presence: true
  validates :description, presence: true

  enum issuer: [:axon, :tutor]
  enum single_use: [:true, :false]  # single_use default is :true, meaning a promotion only discounts one appt in a booking with multiple appointments
                                    # if single_use is set to false, a promotion will discount all sessions in a booking (if redemption limit permits x number of redemptions) - this is useful for semester packages from tutors

  def self.redeem_promo_code(promo_code, appt_rate, number_of_appts, tutor_id, course_id) # this assumes that multiple appts in one booking are all for the same tutor_course (i.e. the rate is the same for each appt)
    promotion = Promotion.find_by(code: promo_code)
    if promotion.nil?
      return {success: false, error: 'Promo code was not found. Please try again or contact support at info@axontutors.com.'}
    else
      validity_check = promotion.check_validity(tutor_id, course_id)
      if validity_check[:success] == false
        return {success: false, error: validity_check[:error]}
      else
        return promotion.process_discount(appt_rate, number_of_appts)
      end
    end
  end

  def check_validity(tutor_id, course_id)
    if Date.today > self.valid_until
      return {success: false, error: "We're sorry but this promo code expired on #{self.valid_until}"}
    elsif self.redemption_count >= self.redemption_limit
      return {success: false, error: "We're sorry but this promo code has expired. It has reached its set redemption limit."}
    elsif self.issuer == 'tutor'
      if self.tutor_id != tutor_id
        return {success: false, error: "This promo code is only valid for appointments with the following tutor: #{Tutor.find(tutor_id).public_name}"}
      elsif self.course_id && self.course_id != course_id
        return {success: false, error: "This promo code is only valid with #{Tutor.find(tutor_id).public_name} for the following course: #{Course.find(course_id).formatted_name}"}
      end  
    end
    return {success: true}
  end

  def process_discount(appt_rate, number_of_appts)
    if self.issuer == 'axon'
      self.process_axon_discount(appt_rate, number_of_appts)
    else
      self.process_tutor_discount(appt_rate, number_of_appts)
    end
  end

  def process_axon_discount(appt_rate, number_of_appts)
    # normal prices for one appt
    single_appt_tutor_fee = appt_rate * 100 
    single_appt_full_price = single_appt_tutor_fee * 1.15
    
    # normal prices for all appts in booking
    tutor_fee = appt_rate * number_of_appts * 100
    full_price =  (tutor_fee * 1.15).round   # TODO-JT - add in school transaction percentage if we need to be able to change for different schools
    
    # discount calculations
    discount = (1 - (self.amount.to_f / 100)) # if promo amount is 10 (i.e. 10%), then discount equals 0.9 (i.e. 90% of normal price)
    if self.single_use == true
      discount_price = (full_price - (appt_rate * 1.15) + (appt_rate * 1.15 * discount)).round
    else
      discount_price = (full_price * discount).round
    end
    discount_value = full_price - discount_price

    # axon fees before and after discount
    full_axon_fee = full_price - tutor_fee
    discount_axon_fee = full_axon_fee - discount_value
    
    return {
      full_price: full_price,
      discount_price: discount_price,
      discount_value: discount_value,
      full_tutor_fee: tutor_fee,
      full_axon_fee: full_axon_fee,
      discount_axon_fee: discount_axon_fee,
      promotion_id: self.id,
      description: self.description
    }
  end

  def process_tutor_discount(appt_rate, number_of_appts)
    # normal prices for one appt
    single_appt_tutor_fee = appt_rate * 100 
    tutor_fee = single_appt_tutor_fee * number_of_appts
    
    # discount calculations
    discount = (1 - (self.amount.to_f / 100)) # if promo amount is 10 (i.e. 10%), then discount equals 0.9 (i.e. 90% of normal price)
    if self.single_use == true
      discount_tutor_fee = (tutor_fee - single_appt_tutor_fee + (single_appt_tutor_fee * discount)).round
    else
      discount_tutor_fee = (tutor_fee * discount).round
    end

    full_price = (tutor_fee * 1.15).round
    discount_price = (discount_tutor_fee * 1.15).round
    discount_value = full_price - discount_price
    discount_axon_fee = discount_price - discount_tutor_fee

    return {
      full_price: full_price,
      discount_price: discount_price,
      discount_value: discount_value,
      discount_tutor_fee: discount_tutor_fee,
      discount_axon_fee: discount_axon_fee,
      promotion_id: self.id,
      description: self.description
    }
  end

  # x = Promotion.new(code: 'AXON10OFF', issuer: 0, amount: 10, valid_from: Date.today - 1, valid_until: Date.today + 100, redemption_limit: 3, redemption_count: 0, description: '10% off one session', single_use: 0)
  # Promotion.redeem_promo_code('AXON10OFF', 20, 3, 1, 1)
  # sprintf('%.2f', 

  # x = Promotion.new(code: 'TUTOR50OFF', issuer: 1, amount: 50, valid_from: Date.today - 1, valid_until: Date.today + 100, redemption_limit: 3, redemption_count: 0, description: '50% off one session', single_use: 0, tutor_id: )
  # Promotion.redeem_promo_code('TUTOR50OFF', 20, 3, 1, 1)

end