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
#

require 'rails_helper'

RSpec.describe Promotion, type: :model do

  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @wrong_tutor = create(:tutor, :with_tutor_course_and_slot)
    @tutor_course = @tutor.tutor_courses.first
    @wrong_tutor_course = @wrong_tutor.tutor_courses.first
    @student = create(:student)
  end

  describe 'redeem_promo_code class method' do
    # Promotion.redeem_promo_code(promo_code, tc_rate, number_of_appts, tutor_id, course_id, student_id=nil)

    ##
    # EXPECTED FAILURES

    it 'fails and sends error message for unknown promo code' do
      @promo = create(:promotion)

      response = Promotion.redeem_promo_code('INCORRECTCODE', 2000, 1, 1, 1, 1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'code was not found'
    end

    it 'fails and sends error message for an expired promo code' do
      @promo = create(:promotion, :expired)

      response = Promotion.redeem_promo_code(@promo.code, 2000, 1, 1, 1, 1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'promo code has expired'
    end

    it 'fails and sends error message for promo code that has reached redemption limit' do
      @promo = create(:promotion, :reached_redemption_limit)

      response = Promotion.redeem_promo_code(@promo.code, 2000, 1, 1, 1, 1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'promo code has expired'
    end

    it 'fails and sends error message for Tutor promo code entered for wrong tutor' do
      @promo = create(:promotion, :tutor_issued)

      response = Promotion.redeem_promo_code(@promo.code, 2000, 1, 99, 1, 1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'tutor'
    end

    it 'fails and sends error message for Tutor promo code with course restriction entered for wrong course' do
      @promo = create(:promotion, :tutor_and_course_specific)

      response = Promotion.redeem_promo_code(@promo.code, 2000, 1, 1, @wrong_tutor_course.id, 1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'course'
    end

    ##
    # Expected Successes with Axon-issued codes

    it 'correctly calculates discount for booking with 1 appt and 10% off single-appt Axon coupon' do
      @promo = create(:promotion)

      response = Promotion.redeem_promo_code(@promo.code,2000,1,nil,nil)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 2300
      expect(response[:discount_price]).to eq 2070
      expect(response[:discount_value]).to eq 230
      expect(response[:regular_tutor_fee]).to eq 2000
      expect(response[:regular_axon_fee]).to eq 300
      expect(response[:discount_axon_fee]).to eq 70
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    it 'correctly calculates discount for booking with 3 appts and 10% off single-appt Axon coupon' do
      @promo = create(:promotion)

      response = Promotion.redeem_promo_code(@promo.code,2000,3,nil,nil)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 6900
      expect(response[:discount_price]).to eq 6670
      expect(response[:discount_value]).to eq 230
      expect(response[:regular_tutor_fee]).to eq 6000
      expect(response[:regular_axon_fee]).to eq 900
      expect(response[:discount_axon_fee]).to eq 670
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    it 'correctly calculates discount for booking with 3 appts and 10% off multiple-appts Axon coupon' do
      @promo = create(:promotion, single_appt: 1)

      response = Promotion.redeem_promo_code(@promo.code,2000,3,nil,nil)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 6900
      expect(response[:discount_price]).to eq 6210
      expect(response[:discount_value]).to eq 690
      expect(response[:regular_tutor_fee]).to eq 6000
      expect(response[:regular_axon_fee]).to eq 900
      expect(response[:discount_axon_fee]).to eq 210
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    it 'correctly calculates discount for booking with 2 appts and 50% off single-appt Axon coupon' do
      @promo = create(:promotion, amount: 50)

      response = Promotion.redeem_promo_code(@promo.code,2000,2,nil,nil)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 4600
      expect(response[:discount_price]).to eq 3450
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 4000
      expect(response[:regular_axon_fee]).to eq 600
      expect(response[:discount_axon_fee]).to eq -550
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    ###
    # Expected successes with Tutor-issed codes

    it 'correctly calculates discount for booking with 1 appt and 50% off single-appt Tutor coupon' do
      @promo = create(:promotion, :tutor_single_appt_50)

      response = Promotion.redeem_promo_code(@promo.code,2000,1,@tutor.id,@tutor_course.course.id,@student.id)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 2300
      expect(response[:discount_price]).to eq 1150
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 2000
      expect(response[:discount_tutor_fee]).to eq 1000
      expect(response[:discount_axon_fee]).to eq 150
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    it 'correctly calculates discount for booking with 2 appts and 25% off single-appt Tutor coupon' do
      @promo = create(:promotion, :tutor_single_appt_25)

      response = Promotion.redeem_promo_code(@promo.code,2000,2,@tutor.id,@tutor_course.course.id,@student.id)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 4600
      expect(response[:discount_price]).to eq 4025
      expect(response[:discount_value]).to eq 575
      expect(response[:regular_tutor_fee]).to eq 4000
      expect(response[:discount_tutor_fee]).to eq 3500
      expect(response[:discount_axon_fee]).to eq 525
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    it 'correctly calculates discount for booking with 5 appts and 10% off multiple-appts Tutor coupon' do
      @promo = create(:promotion, :tutor_multiple_appts)

      response = Promotion.redeem_promo_code(@promo.code,2000,5,1,1,1)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 11500
      expect(response[:discount_price]).to eq 10350
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 10000
      expect(response[:discount_tutor_fee]).to eq 9000
      expect(response[:discount_axon_fee]).to eq 1350
      expect(response[:promotion_id]).to eq @promo.id
      expect(response[:description]).to eq @promo.description
    end

    ###
    # Expected responses for codes that are limited to one use per student

    it 'correctly succeeds applying uniq_enforced promo for student on first use' do
      @promo = create(:promotion)

      response = Promotion.redeem_promo_code(@promo.code,2000,1,@tutor.id,@tutor_course.course.id)
      expect(response[:error]).to eq nil
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 2300
      expect(response[:discount_price]).to eq 2070
      expect(response[:discount_value]).to eq 230
      expect(response[:regular_tutor_fee]).to eq 2000
      expect(response[:discount_tutor_fee]).to eq 2000
      expect(response[:regular_axon_fee]).to eq 300
      expect(response[:discount_axon_fee]).to eq 70
      expect(response[:promotion_id]).to eq @promo.id
    end

    it 'correctly succeeds applying uniq_enforced promo for student on first use' do
      @promo = create(:promotion, tutor_id: @tutor.id)

      StudentsPromotions.create(student_id: @student.id, promotion_id: @promo.id)

      response = Promotion.redeem_promo_code(@promo.code, 2000, 1, @tutor.id,@tutor_course.course.id, @student.id)
      expect(response[:success]).to eq false
      expect(response[:error]).to eq 'This promo code only allows you to use it once. According to our records you have already redeemed it.'
    end

  end
end
