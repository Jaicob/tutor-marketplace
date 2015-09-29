require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::PercentOffFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:different_tutor) { create(:second_complete_tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::PercentOffFromTutor' do

    before :each do
      @promotion = create(:promotion, category: :percent_off_from_tutor, tutor_id: tutor.id)
    end

    it 'correctly adjusts fees for a 10%-off coupon issued by a Tutor' do 
      @promotion.update(amount: 10)
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2380
      expect(@context.charge.tutor_fee).to eq 2070
      expect(@context.charge.axon_fee).to eq 310
    end

    it 'correctly adjusts fees for a 25%-off coupon issued by a Tutor' do 
      @promotion.update(amount: 25)
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1983
      expect(@context.charge.tutor_fee).to eq 1725
      expect(@context.charge.axon_fee).to eq 258
    end

    it 'correctly adjusts fees for a 50%-off coupon issued by a Tutor' do 
      @promotion.update(amount: 50)
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 1322
      expect(@context.charge.tutor_fee).to eq 1150
      expect(@context.charge.axon_fee).to eq 172
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@promotion.redemption_count).to eq 0
      @context.return_adjusted_fees
      expect(@promotion.reload.redemption_count).to eq 1
    end

    it 'does not give discount for expired promo_code' do
      @promotion.update(valid_from: Date.today - 300, valid_until: Date.today - 299) 
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end

    it 'does not give discount for promo_code if code is past redemption_limit' do 
      @promotion.update(redemption_limit: 100, redemption_count: 100)
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
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
      @context = PromoCodeHelpers::PercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end
  end
end