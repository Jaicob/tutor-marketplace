require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::FreeSessionFromAxon' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::FreeSessionFromAxon' do
  
    it 'adjusts fees for a free_session coupon issued by Axon' do 
      @promotion = create(:promotion, category: :free_from_axon, amount: 1)
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
      @context = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 0
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -2300
    end

    it 'only gives one free session (the cheapest one) in a booking with multiple appointments' do 
      @promotion = create(:promotion, category: :free_from_axon, amount: 1)
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
      @context = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(@context.charge.amount).to eq 7819
      expect(@context.charge.tutor_fee).to eq 6800
      expect(@context.charge.axon_fee).to eq 1019
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 6094
      expect(@context.charge.tutor_fee).to eq 6800
      expect(@context.charge.axon_fee).to eq -706
    end

    it 'only gives one free session (the cheapest one) in a booking with multiple appointments (#2)' do 
      @promotion = create(:promotion, category: :free_from_axon, amount: 1)
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
      @context = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(@context.charge.amount).to eq 4024
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq 524
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2299
      expect(@context.charge.tutor_fee).to eq 3500
      expect(@context.charge.axon_fee).to eq -1201
    end

  end
end