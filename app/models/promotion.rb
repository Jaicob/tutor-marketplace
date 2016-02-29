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
#  repeat_use       :integer          default(0)
#  student_id       :integer
#  single_appt      :integer
#  redeemer         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Promotion < ActiveRecord::Base
  belongs_to :tutor # nil is OK, if nil, then promo is Axon-issed
  has_many :students_promotions, class_name: StudentsPromotions
  has_many :students, through: :students_promotions

  validates :code, presence: true, uniqueness: true
  validates :redemption_limit, :valid_from, :valid_until, :description, :issuer, presence: true
  validate  :tutor_issued_must_have_tutor_id
  validate  :redeemer_specific_student_must_have_student_id

  enum issuer:      [:axon, :tutor]
  enum single_appt: [:single, :multiple]
  enum repeat_use:  [:no_repeat, :repeat]
  enum redeemer:    [:any_student, :specific_student, :student_group]

  ## For Testing
  #
  # Promotion.new(code: 'testcode', issuer: 0, amount: 100, valid_from: Date.today, valid_until: Date.today + 100, redemption_limit: 100, description: 'Free Session From Axon - One Per Student', repeat_use: 0, single_appt: 0, redeemer: 0)

  # custom validation
  def tutor_issued_must_have_tutor_id
    if issuer == 'tutor'
      if tutor_id.nil?
        errors.add(:tutor_id, "cannot be blank for Tutor issued promotion")
      end
    end
  end

  # custom validation
  def redeemer_specific_student_must_have_student_id
    if redeemer == 'specific_student'
      if student_id.nil?
        errors.add(:student_id, "cannot be blank for Student specific promotion")
      end
    end
  end

  # custom validation
  def course_and_tutor_at_same_school
    tutor_school_id = Tutor.find(tutor_id).school.id
    course_school_id = Course.find(course_id).school.id
    if tutor_school_id != course_school_id
      errors.add(:tutor, "and course are not at same school. Invalid promo code.")
    end
  end

  # TODO-JT - Discuss with Jaicob - could be refactored into using a relationship? Putting an appt_id attribute on StudentsPromotions model?
  def charges
    charges = []
    self.students.each do |student|
      student.charges.each do |charge|
        if charge.promotion_id == self.id
          charges << charge
        end
      end
    end
    return charges
  end

  # IMPORTANT - PASS IN TC_RATE in CENTS!
  def self.redeem_promo_code(promo_code, tc_rate, number_of_appts, tutor_id, course_id, student_id=nil, receipt_only=nil) # this assumes that multiple appts in one booking are all for the same tutor_course (i.e. the rate is the same for each appt)
    promotion = Promotion.find_by(code: promo_code)
    if promotion.nil?
      return {success: false, error: 'Promo code was not found. Please try again or contact support at info@axontutors.com.'}
    else
      validity_check = promotion.check_validity(tutor_id, course_id, student_id)
      if validity_check[:success] == false && receipt_only != true
        return {success: false, error: validity_check[:error]}
      else
        promotion.process_discount(tc_rate, number_of_appts)
      end
    end
  end

  def check_validity(tutor_id, course_id, student_id=nil)
    # check if code is past expiration date, after start_date
    if Date.today > self.valid_until || Date.today < self.valid_from
      return {success: false, error: "This promo code has expired."}
    end

    # check if code is past redemption_limit
    if self.redemption_count >= self.redemption_limit
      return {success: false, error: "This promo code has expired."}
    end

    # check if course being booked matches course_id on any promo with a course restriction
    if self.course_id.present?
      # if promo code has course restriction on it, raise error if course being booked does not match course_id on promo code
      if self.course_id != course_id
        return {success: false, error: "This promo code is only valid for the following course: #{Course.find(course_id).formatted_name}"}
      end
    end

    # if promo code is tutor-issued, raise error if tutor being booked does not match tutor_id on promo code
    if self.tutor_id.present? && self.tutor_id != tutor_id
      return {success: false, error: "This promo code is not valid for this tutor."}
    end

    # check specific redeemer restrictons
    case self.redeemer

    when 'any_student'
      # student must be logged in for check to work
      if student_id.present?
        # check if student checking out has redeemed this promo code before
        # currently only returns and raises error if student has used promo code before, otherwise does nothing
        if self.repeat_use == 'no_repeat'
          if Student.find(student_id).students_promotions.where(promotion_id: self.id).any?
            return {success: false, error: "This promo code only allows you to use it once. According to our records you have already redeemed it."}
          end
        end
      end

    when 'specific_student'
      # student must be logged in + check if student correct student for student specific promo code
      if student_id.present? && self.student_id == student_id
        # if promo code is only good for one use, raise error if student has already used before
        if self.repeat_use == 'no_repeat'
          return {success: false, error: "This promo code only allows you to use it once. According to our records you have already redeemed it."}
        end
      else
        # error message for two cases: 1) student is not yet logged in, 2) student is logged in and is trying to use promo code intended for another student
        return {success: false, error: "This promo code is intended for use by a specific student. You must log in to the correct student account for this promo code to be applied."}
      end

    when 'student_group'
      # TODO-JT - create current StudentGroups and add student_group_id to associated student records
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
    if self.single_appt == 'single'
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
    if self.single_appt == 'single'
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
