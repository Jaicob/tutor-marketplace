require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::ApplyPercentOffFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::ApplyPercentOffFromTutor' do

    it 'correctly adjusts fees for a 10%-off coupon' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 10)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [20, 30],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5750
      expect(@context.charge.tutor_fee).to eq 5000
      expect(@context.charge.axon_fee).to eq 750
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 5520
      expect(@context.charge.tutor_fee).to eq 4800
      expect(@context.charge.axon_fee).to eq 720
    end

    it 'correctly adjusts fees for a 25%-off coupon' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 25)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [20, 30],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5750
      expect(@context.charge.tutor_fee).to eq 5000
      expect(@context.charge.axon_fee).to eq 750
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 5175
      expect(@context.charge.tutor_fee).to eq 4500
      expect(@context.charge.axon_fee).to eq 675
    end

    it 'correctly adjusts fees for a 50%-off coupon' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 50)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [20, 30],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5750
      expect(@context.charge.tutor_fee).to eq 5000
      expect(@context.charge.axon_fee).to eq 750
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4600
      expect(@context.charge.tutor_fee).to eq 4000
      expect(@context.charge.axon_fee).to eq 600
    end
  end
end