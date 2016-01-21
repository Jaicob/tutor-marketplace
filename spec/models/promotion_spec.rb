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

require 'rails_helper'

RSpec.describe Promotion, type: :model do
  
  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @wrong_tutor = create(:tutor)
    @tutor_course = @tutor.tutor_courses.first
  end

  describe 'redeem_promo_code class method' do
  # Promotion.redeem_promo_code(promo_code, tc_rate, number_of_appts, tutor_id, course_id) 

  ##
  # EXPECTED FAILURES

    it 'fails and sends error message for unknown promo code' do 
      @promotion = create(:promotion, code: 'COUPONCODE')

      response = Promotion.redeem_promo_code('INCORRECTCODE',2000,2,1,1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'code was not found'
    end
  
    it 'fails and sends error message for an expired promo code' do 
      @promotion = create(:promotion, valid_until: Date.today - 1)
      
      response = Promotion.redeem_promo_code('AXON10%OFF',2000,2,1,1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'this promo code expired on'
    end

    it 'fails and sends error message for promo code that has reached redemption limit' do
      @promotion = create(:promotion, redemption_limit: 1, redemption_count: 1)

      response = Promotion.redeem_promo_code('AXON10%OFF',2000,2,1,1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'has reached its set redemption limit'
    end

    it 'fails and sends error message for Tutor promo code entered for wrong tutor' do
      @promotion = create(:promotion, code: 'TUTOR20%OFF', issuer: 1, tutor_id: @tutor.id)

      response = Promotion.redeem_promo_code('TUTOR20%OFF',2000,2,@wrong_tutor.id,1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'tutor'
    end

    it 'fails and sends error message for Tutor promo code with course restriction entered for wrong course' do
      @promotion = create(:promotion, code: 'TUTOR20%OFF', issuer: 1, course_id: 99, tutor_id: @tutor.id)

      response = Promotion.redeem_promo_code('TUTOR20%OFF',2000,2,@tutor.id,1)
      expect(response[:success]).to eq false
      expect(response[:error]).to include 'course'
    end

    ##
    # Expected Successes with Axon-issued codes

    it 'correctly calculates discount for booking with 1 appt and single-use 10% off Axon coupon' do
      @promotion = create(:promotion, code: 'AXON10%OFF', single_use: 0)

      response = Promotion.redeem_promo_code('AXON10%OFF',2000,1,nil,nil)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 2300
      expect(response[:discount_price]).to eq 2070
      expect(response[:discount_value]).to eq 230
      expect(response[:regular_tutor_fee]).to eq 2000
      expect(response[:regular_axon_fee]).to eq 300
      expect(response[:discount_axon_fee]).to eq 70
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    it 'correctly calculates discount for booking with 3 appts and single-use 10% off Axon coupon' do
      @promotion = create(:promotion, code: 'AXON10%OFF', single_use: 0)

      response = Promotion.redeem_promo_code('AXON10%OFF',2000,3,nil,nil)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 6900
      expect(response[:discount_price]).to eq 6670
      expect(response[:discount_value]).to eq 230
      expect(response[:regular_tutor_fee]).to eq 6000
      expect(response[:regular_axon_fee]).to eq 900
      expect(response[:discount_axon_fee]).to eq 670
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    it 'correctly calculates discount for booking with 3 appts and multiple-use 10% off Axon coupon' do
      @promotion = create(:promotion, code: 'AXON10%OFF', single_use: 1)

      response = Promotion.redeem_promo_code('AXON10%OFF',2000,3,nil,nil)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 6900
      expect(response[:discount_price]).to eq 6210
      expect(response[:discount_value]).to eq 690
      expect(response[:regular_tutor_fee]).to eq 6000
      expect(response[:regular_axon_fee]).to eq 900
      expect(response[:discount_axon_fee]).to eq 210
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    it 'correctly calculates discount for booking with 2 appts and single-use 50% off Axon coupon' do
      @promotion = create(:promotion, code: 'AXON10%OFF', single_use: 0, amount: 50)

      response = Promotion.redeem_promo_code('AXON10%OFF',2000,2,nil,nil)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 4600
      expect(response[:discount_price]).to eq 3450
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 4000
      expect(response[:regular_axon_fee]).to eq 600
      expect(response[:discount_axon_fee]).to eq -550
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    ###
    # Expected successes with Tutor-issed codes

    it 'correctly calculates discount for booking with 1 appt and single-use 50% off Tutor coupon' do
      @promotion = create(:promotion, code: 'TUTOR50%OFF', issuer: 1, tutor_id: @tutor.id, amount: 50, single_use: 0)

      response = Promotion.redeem_promo_code('TUTOR50%OFF',2000,1,@tutor.id,@tutor_course.course.id)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 2300
      expect(response[:discount_price]).to eq 1150
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 2000
      expect(response[:discount_tutor_fee]).to eq 1000
      expect(response[:discount_axon_fee]).to eq 150
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    it 'correctly calculates discount for booking with 2 appts and single-use 25% off Tutor coupon' do
      @promotion = create(:promotion, code: 'TUTOR25%OFF', issuer: 1, tutor_id: @tutor.id, amount: 25, single_use: 0)

      response = Promotion.redeem_promo_code('TUTOR25%OFF',2000,2,@tutor.id,@tutor_course.course.id)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 4600
      expect(response[:discount_price]).to eq 4025
      expect(response[:discount_value]).to eq 575
      expect(response[:regular_tutor_fee]).to eq 4000
      expect(response[:discount_tutor_fee]).to eq 3500
      expect(response[:discount_axon_fee]).to eq 525
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

    it 'correctly calculates discount for booking with 5 appts and multiple-use 10% off Tutor coupon' do
      @promotion = create(:promotion, code: 'TUTOR10%0FFSEMESTER', issuer: 1, single_use: 1, amount: 10, tutor_id: @tutor.id)

      response = Promotion.redeem_promo_code('TUTOR10%0FFSEMESTER',2000,5,@tutor.id,@tutor_course.course.id)
      expect(response[:success]).to eq true
      expect(response[:regular_price]).to eq 11500
      expect(response[:discount_price]).to eq 10350
      expect(response[:discount_value]).to eq 1150
      expect(response[:regular_tutor_fee]).to eq 10000
      expect(response[:discount_tutor_fee]).to eq 9000
      expect(response[:discount_axon_fee]).to eq 1350
      expect(response[:promotion_id]).to eq @promotion.id
      expect(response[:description]).to eq @promotion.description
    end

  end
end