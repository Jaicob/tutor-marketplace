require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::DollarAmountOffFromAxon' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::DollarAmountOffFromAxon' do

    it 'correctly adjusts fees for a $5-off coupon issued by Axon' do 
      @promotion = create(:promotion, category: :dollar_amount_off_from_axon, amount: 5)
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
      @context = PromoCodeHelpers::ApplyDollarAmountOffFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2145
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -155
    end

    it 'correctly adjusts fees for a $10-off coupon issued by Axon' do 
      @promotion = create(:promotion, category: :dollar_amount_off_from_axon, amount: 10)
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
      @context = PromoCodeHelpers::ApplyDollarAmountOffFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -655
    end

    it 'correctly adjusts fees for a $20-off coupon issued by Axon' do 
      @promotion = create(:promotion, category: :dollar_amount_off_from_axon, amount: 20)
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
      @context = PromoCodeHelpers::ApplyDollarAmountOffFromAxon.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq -1655
    end
  end
end