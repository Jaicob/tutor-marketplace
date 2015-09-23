require 'rails_helper'

# This file tests the ApplyPromoCode interactor's apply_dollar_amount_off_promo method with various appointments being booked

RSpec.describe "ApplyPromoCode's percent_off_promo method" do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }
  let(:appointment_2) { create(:appointment, :second)}

  describe 'Checkout with TWO APPOINTMENTS and a 10%-off coupon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :percent_off, amount: 10)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [20,30],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      # the CreateCharge.call isn't being tested here, but it's necessary set up (to create the charge)
      @setup = CreateCharge.call(params)
    end 

    it 'assigns the promotion_id to charge.promotion_id' do
      expect(@setup.charge.promotion_id).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.promotion_id).to eq @promotion.id
    end

    it 'sets context.is_payment_required to true' do
      expect(@setup.is_payment_required).to eq true
      context = ApplyPromoCode.call(@setup)
      expect(context.is_payment_required).to eq true
    end

    it 'finds the multiplier to calculate percent off discount' do 
      expect(@setup.percent_off_discount_multiplier).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.percent_off_discount_multiplier).to eq 0.90
    end

    it 'finds the rate of the least expensive session' do 
      expect(@setup.lowest_rate).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate).to eq 20
    end

    it 'calculates the normal full-price (fee included) for the least expensive session' do 
      expect(@setup.lowest_rate_full_price).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate_full_price).to eq 2300
    end

    it 'applies the discount multiplier to the full-price to determine discount price' do
      expect(@setup.lowest_rate_discount_price).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate_discount_price).to eq 2070 
    end

    it 'substitues the full price rate with the discount rate for the one session to calculate new amount' do
      expect(@setup.charge.amount).to eq 5750
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.amount).to eq 5520
    end
  end


  describe 'Checkout with THREE APPOINTMENTS and a 50%-off coupon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :percent_off, amount: 50)
      params = {
        tutor: tutor,
        appointments: [appointment, appointment_2],
        customer_id: 1,
        token: 1111111111,
        rates: [30, 35, 32],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      # the CreateCharge.call isn't being tested here, but it's necessary set up (to create the charge)
      @setup = CreateCharge.call(params)
    end 

    it 'finds the multiplier to calculate percent off discount' do 
      expect(@setup.percent_off_discount_multiplier).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.percent_off_discount_multiplier).to eq 0.50
    end

    it 'finds the rate of the least expensive session' do 
      expect(@setup.lowest_rate).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate).to eq 30
    end

    it 'calculates the normal full-price (fee included) for the least expensive session' do 
      expect(@setup.lowest_rate_full_price).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate_full_price).to eq 3450
    end

    it 'applies the discount multiplier to the full-price to determine discount price' do
      expect(@setup.lowest_rate_discount_price).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.lowest_rate_discount_price).to eq 1725
    end

    it 'substitues the full price rate with the discount rate for the one session to calculate new amount' do
      expect(@setup.charge.amount).to eq 11155
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.amount).to eq 9430
    end
  end

end