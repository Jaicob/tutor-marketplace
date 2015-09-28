require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::PercentOffFromAxon' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::PercentOffFromAxon' do
    
    it 'correctly adjusts fees for a 10%-off coupon issued by Axon' do
      @promotion = create(:promotion, category: :percent_off_from_axon, amount: 10)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromAxon.new(context)
 
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2381
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 81
    end

    it 'correctly adjusts fees for a 25%-off coupon issued by Axon' do 
      @promotion = create(:promotion, category: :percent_off_from_axon, amount: 25)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1984
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -316
    end

    it 'correctly adjusts fees for a 50%-off coupon issued by Axon' do 
      @promotion = create(:promotion, category: :percent_off_from_axon, amount: 50)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1323
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -977
    end

  end
end