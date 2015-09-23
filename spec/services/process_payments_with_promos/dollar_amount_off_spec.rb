require 'rails_helper'

# This file tests the ApplyPromoCode interactor's apply_dollar_amount_off_promo method with various appointments being booked

RSpec.describe "ApplyPromoCode's dollar_off_amount_promo" do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'checkout with one appointment and a $10 off coupon' do
    
    before :each do

      @promotion = create(:promotion, category: :dollar_amount_off, amount: 10)
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
      # the CreateCharge.call isn't being tested here, but it's necessary set up (to create the charge)
      @context = CreateCharge.call(params)
    end 

    it 'assigns the promotion_id to charge.promotion_id' do
      expect(@context.charge.promotion_id).to eq nil
      context = ApplyPromoCode.call(@context)
      expect(context.charge.promotion_id).to eq @promotion.id
    end

    it 'sets context.is_payment_required to true' do
      expect(@context.is_payment_required).to eq true
      context = ApplyPromoCode.call(@context)
      expect(context.is_payment_required).to eq true
    end

    it 'finds the cash value of the promo code in cents' do 
      expect(@context.promotion_discount).to eq nil
      context = ApplyPromoCode.call(@context)
      expect(@context.promotion_discount).to eq 1000
    end

  end


end


      # # record promotion_id on charge
      # context.charge.update(promotion_id: context.promotion_id)
      # # flag charge as requiring payment
      # context.is_payment_required = true
      # # find cash value of promo code (in cents!)
      # promotion = Promotion.find(context.promotion_id)
      # promotion_discount = promotion.amount * 100
      # # decrease amount by promotion discount
      # context.charge.amount = context.charge.amount - promotion_discount
      # # calculate if Axon owes the tutor any $ so that tutor receives full pay on discounted appt
      # axon_owes_tutor = context.charge.tutor_fee - context.charge.amount
      # if axon_owes_tutor > 0
      #   context.charge.axon_fee = 0
      #   context.charge.tutor_fee = context.charge.amount
      # end
      # context.axon_owes_tutor = axon_owes_tutor