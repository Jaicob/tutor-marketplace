require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::FreeSessionFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:different_tutor) { create(:second_complete_tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::FreeSessionFromTutor' do

    before :each do 
       @promotion = create(:promotion, category: :free_from_tutor, tutor_id: tutor.id, amount: 10)
    end
  
    it 'adjusts fees for a free_session coupon issued by Tutor' do 
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 0
      expect(@context.charge.tutor_fee).to eq 0
      expect(@context.charge.axon_fee).to eq 0
    end

    it 'only gives one free session (the cheapest one) in a booking with multiple appointments' do 
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [15, 23, 30],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 7819
      expect(@context.charge.tutor_fee).to eq 6800
      expect(@context.charge.axon_fee).to eq 1019
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 6095
      expect(@context.charge.tutor_fee).to eq 5300
      expect(@context.charge.axon_fee).to eq 795
    end

    it 'only gives one free session (the cheapest one) in a booking with multiple appointments (#2)' do 
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [15, 20],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2300
      expect(@context.charge.tutor_fee).to eq 2000
      expect(@context.charge.axon_fee).to eq 300
    end

    it 'increments the redemption_count for a promotion by 1 when succesfully applied' do
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@promotion.redemption_count).to eq 0
      @context.return_adjusted_fees
      expect(@promotion.reload.redemption_count).to eq 1
    end

    it 'does not give discount for promo_code if code is past redemption_limit' do 
      @promotion.update(redemption_limit: 100, redemption_count: 100)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [15, 20],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
    end
    
    it 'does not give discount for expired promo_code' do
      @promotion.update(valid_from: Date.today - 300, valid_until: Date.today - 299) 
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [15, 20],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
    end

    it 'does not give discount if tutor on promo_code and charge are not the same' do 
      @promotion.update(tutor_id: different_tutor.id) 
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end

    it 'is_payment_required is false with valid free session code on booking with only one session' do
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [20],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::FreeSessionFromTutor.new(context)

      expect(@context.charge.amount).to eq 2300
      expect(@context.charge.tutor_fee).to eq 2000
      expect(@context.charge.axon_fee).to eq 300
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 0
      expect(@context.charge.tutor_fee).to eq 0
      expect(@context.charge.axon_fee).to eq 0
      expect(@context.is_payment_required).to eq false
    end

  end
end