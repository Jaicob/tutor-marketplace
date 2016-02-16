# == Schema Information
#
# Table name: promotions
#
#  id                    :integer          not null, primary key
#  code                  :string
#  issuer                :integer
#  amount                :integer
#  valid_from            :date
#  valid_until           :date
#  redemption_limit      :integer
#  redemption_count      :integer          default(0)
#  description           :text
#  tutor_id              :integer
#  course_id             :integer
#  reedemer_restrictions :integer          default(0)
#  student_group_id      :integer
#  student_id            :integer
#

class Promotion < ActiveRecord::Base
  belongs_to :tutor # nil is OK, if nil, then promo is Axon-issed
  belongs_to :student_group # nil is OK, if nil, then promo is not for a student_group
  has_many :promotion_redemptions
  has_many :students, through: :students_promotions

  validates :code, presence: true, uniqueness: true
  validates :redemption_limit, :valid_from, :valid_until, :description, :issuer, presence: true
  validate  :tutor_issued_must_have_tutor_id
  validate  :one_student_promo_must_have_student_id
  validate  :student_group_promo_must_have_student_group_id

  enum issuer: [:axon, :tutor]
  enum redeemer_restrictions: [:any_student_once, :one_student_multiple, :student_group_multiple] # for detailed description of different types, see Promotions Requirements doc in Google Drive Dev/Requirements folder
  # may potentially add two more later => :one_student_once, :any_student_multiple

  def tutor_issued_must_have_tutor_id
    if issuer == 'tutor'
      if tutor_id.nil?
        errors.add(:tutor_id, "cannot be blank for Tutor issued promotion")
      end
    end
  end

  def one_student_promo_must_have_student_id
    if redeemer_restrictions == 'one_student_multiple'
      if student_id.nil?
        errors.add(:student_id, "cannot be blank for Student specific promotion")
      end
    end
  end

  def student_group_promo_must_have_student_group_id
    if redeemer_restrictions == 'student_group_multiple'
      if student_group_id.nil?
        errors.add(:student_group_id, "cannot be blank for StudentGroup promotion")
      end
    end
  end

  def course_and_tutor_at_same_school
    tutor_school_id = Tutor.find(tutor_id).school.id
    course_school_id = Course.find(course_id).school.id
    if tutor_school_id != course_school_id
      errors.add(:tutor, "cannot add courses from different school")
    end
  end

  # IMPORTANT - PASS IN TC_RATE in CENTS!
  def self.redeem_promo_code(promo_code, tc_rate, number_of_appts, tutor_id, course_id, student_id=nil) # this assumes that multiple appts in one booking are all for the same tutor_course (i.e. the rate is the same for each appt)
    promotion = Promotion.find_by(code: promo_code)
    if promotion.nil?
      return {success: false, error: 'Promo code was not found. Please try again or contact support at info@axontutors.com.'}
    else
      validity_check = promotion.check_validity(tutor_id, course_id, student_id)
      if validity_check[:success] == false
        return {success: false, error: validity_check[:error]}
      else
        promotion.process_discount(tc_rate, number_of_appts)
      end
    end
  end

  def check_validity(tutor_id, course_id, student_id=nil)
    # check if code is past expiration date
    if Date.today > self.valid_until
      return {success: false, error: "This promo code expired on #{self.valid_until}"}
    end
    
    # check if code is past redemption_limit
    if self.redemption_count >= self.redemption_limit
      return {success: false, error: "This promo code has expired. It has reached its set redemption limit."}
    end
    
    # check specific redeemer_restrictions
    if !student_id.nil? # these methods can only be run when a student is signed in, if an error should rise and prevent promo redemption, it will once they sign in
      if self.redeemer_restrictions == 'any_student_once'
        # check if student checking out has redeemed this promo code before
        if Student.find(student_id).students_promotions.where(promotion_id: self.id).any?
          return {success: false, error: "This promo code only allows you to use it once. According to our records you have already redeemed it."}
        end
      elsif self.redeemer_restrictions == 'one_student_multiple'
        # check if student checking out matches student_id on promotion
        if self.issuer == 'tutor'
          # check if tutor_id matches tutor being booked
          if self.tutor_id != tutor_id
            return {success: false, error: "This promo code is only valid for appointments with the following tutor: #{Tutor.find(tutor.id).public_name}"}
          end
          # check if course_id matches course being booked
          if self.course_id && self.course_id != course_id
            return {success: false, error: "This promo code is only valid with #{Tutor.find(tutor_id).public_name} for the following course: #{Course.find(course_id).formatted_name}"}
          end
        end
      elsif self.redeemer_restrictions == 'student_group_multiple'
        # TODO-JT - create current StudentGroups and add student_group_id to associated student records
      end
    end
    return {success: true}
  end

  def process_discount(tc_rate, number_of_appts)
    if self.issuer == 'axon'
      self.process_axon_discount(tc_rate, number_of_appts)
    else
      self.process_tutor_discount(tc_rate, number_of_appts)
    end
  end

  def process_axon_discount(tc_rate, number_of_appts)
    # normal prices for one appt
    single_appt_tutor_fee = tc_rate
    single_appt_full_price = single_appt_tutor_fee * 1.15
    
    # normal prices for all appts in booking
    regular_tutor_fee = tc_rate * number_of_appts
    regular_price =  (regular_tutor_fee * 1.15)   # TODO-JT - add in school transaction percentage if we need to be able to change for different schools
    
    # discount calculations
    discount = (1 - (self.amount.to_f / 100)) # if promo amount is 10 (i.e. 10%), then discount equals 0.9 (i.e. 90% of normal price)
    if self.single_appt == 'true'
      discount_price = (regular_price - (single_appt_full_price) + (single_appt_full_price * discount))
    else
      discount_price = (regular_price * discount)
    end
    discount_value = regular_price - discount_price

    # axon fees before and after discount
    regular_axon_fee = regular_price - regular_tutor_fee
    discount_axon_fee = regular_axon_fee - discount_value
    
    return {
      success: true,
      regular_price: regular_price.round,
      discount_price: discount_price.round,
      discount_value: discount_value.round,
      regular_tutor_fee: regular_tutor_fee.round,
      discount_tutor_fee: regular_tutor_fee.round, # supposed to be the same here, bc Axon is paying for discount, but still included to keep response data uniform for both promo types
      regular_axon_fee: regular_axon_fee.round,
      discount_axon_fee: discount_axon_fee.round,
      promotion_id: self.id,
      description: self.description
    }
  end

  def process_tutor_discount(tc_rate, number_of_appts)
    # normal prices for one appt
    single_appt_tutor_fee = tc_rate
    regular_tutor_fee = single_appt_tutor_fee * number_of_appts
    
    # discount calculations
    discount = (1 - (self.amount.to_f / 100)) # if promo amount is 10 (i.e. 10%), then discount equals 0.9 (i.e. 90% of normal price)
    if self.single_appt == 'true'
      discount_tutor_fee = (regular_tutor_fee - single_appt_tutor_fee + (single_appt_tutor_fee * discount))
    else
      discount_tutor_fee = (regular_tutor_fee * discount)
    end

    regular_price = (regular_tutor_fee * 1.15)
    discount_price = (discount_tutor_fee * 1.15)
    discount_value = regular_price - discount_price
    discount_axon_fee = discount_price - discount_tutor_fee

    return {
      success: true,
      regular_price: regular_price.round,
      discount_price: discount_price.round,
      discount_value: discount_value.round,
      regular_tutor_fee: regular_tutor_fee.round,
      discount_tutor_fee: discount_tutor_fee.round,
      regular_axon_fee: (regular_price - regular_tutor_fee).round,
      discount_axon_fee: discount_axon_fee.round,
      promotion_id: self.id,
      description: self.description
    }
  end

end
