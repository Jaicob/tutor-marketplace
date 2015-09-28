require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::PercentOffFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::PercentOffFromTutor' do

    it 'correctly adjusts fees for a 10%-off coupon issued by a Tutor' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 10)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2380
      expect(@context.charge.tutor_fee).to eq 2070
      expect(@context.charge.axon_fee).to eq 310
    end

    it 'correctly adjusts fees for a 25%-off coupon issued by a Tutor' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 25)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1983
      expect(@context.charge.tutor_fee).to eq 1725
      expect(@context.charge.axon_fee).to eq 258
    end

    it 'correctly adjusts fees for a 50%-off coupon issued by a Tutor' do 
      @promotion = create(:promotion, category: :percent_off_from_tutor, amount: 50)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1322
      expect(@context.charge.tutor_fee).to eq 1150
      expect(@context.charge.axon_fee).to eq 172
    end
  end
end