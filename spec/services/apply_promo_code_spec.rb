require 'rails_helper'

RSpec.describe ApplyPromoCode do
  let(:tutor)       { build_stubbed(:tutor) }
  let(:appointment) { build_stubbed(:appointment) }


  describe 'checkout with a free_from_axon promo code' do
    before :each do
      promotion = create(:promotion, category: :free_from_axon)
      params = {
        tutor: tutor,
        appointments: appointment,
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ApplyPromoCode.call(params)
    end 

    it 'sets context.is_payment_required to false' do
      expect(@context.is_payment_required).to eq(false)
    end
  end

  describe 'checkout with a free_from_tutor promo code' do
    before :each do
      promotion = create(:promotion, category: :free_from_tutor)
      params = {
        tutor: tutor,
        appointments: appointment,
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ApplyPromoCode.call(params)
    end  

    it 'sets context.is_payment_required to false' do
      expect(@context.is_payment_required).to eq(false)
    end
  end

  describe 'checkout with a percent_off promo code' do 
    before :each do
      promotion = create(:promotion, category: :percent_off)
      params = {
        tutor: tutor,
        appointments: appointment,
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ApplyPromoCode.call(params)
    end 

    it 'sets context.is_payment_required to true' do
      expect(@context.is_payment_required).to eq(true)
    end
  end

  describe 'checkout with a dollar_amount_off promo code' do 
    before :each do
      promotion = create(:promotion, category: :dollar_amount_off)
      params = {
        tutor: tutor,
        appointments: appointment,
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ApplyPromoCode.call(params)
    end 

    it 'sets context.is_payment_required to true' do
      expect(@context.is_payment_required).to eq(true)
    end
  end

  describe 'checkout with a semester_package promo code' do 
    before :each do
      promotion = create(:promotion, category: :semester_package)
      params = {
        tutor: tutor,
        appointments: appointment,
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ApplyPromoCode.call(params)
    end 

    it 'sets context.is_payment_required to false' do
      expect(@context.is_payment_required).to eq(false)
    end
  end


end