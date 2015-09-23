require 'rails_helper'

# This file tests the ApplyPromoCode interactor's apply_dollar_amount_off_promo method with various appointments being booked

RSpec.describe "ApplyPromoCode's dollar_off_amount_promo method" do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }
  let(:appointment_2) { create(:appointment, :second)}

  describe 'Checkout with ONE APPOINTMENT and a $10-OFF coupon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
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

    it 'context.promotion_discount finds promotion value in cents' do 
      expect(@setup.promotion_discount).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.promotion_discount).to eq 1000
    end

    it 'lowers the amount in accordance with the discount' do
      expect(@setup.charge.amount).to eq(2300)
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.amount).to eq(1300)
    end

    it 'calculates the money Axon owes to the tutor because of the discount ' do 
      expect(@setup.axon_owes_tutor).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.axon_owes_tutor).to eq 700
    end

    it 'changes axon_fee amount to 0 if tutor fee is not covered by amount' do 
      expect(@setup.charge.axon_fee).to eq 300
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.axon_fee).to eq 0
    end
  end


  describe 'Checkout with TWO APPOINTMENTS and a $5-OFF coupon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :dollar_amount_off, amount: 5)
      params = {
        tutor: tutor,
        appointments: [appointment, appointment_2],
        customer_id: 1,
        token: 1111111111,
        rates: [20, 25],
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

    it 'finds the cash value of the promo code in cents' do 
      expect(@setup.promotion_discount).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.promotion_discount).to eq 500
    end

    it 'lowers the amount in accordance with the discount' do
      expect(@setup.charge.amount).to eq(5175)
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.amount).to eq(4675)
    end

    it 'calculates the money Axon owes to tutor because of the discount ' do 
      expect(@setup.axon_owes_tutor).to eq nil
      context = ApplyPromoCode.call(@setup)
      expect(context.axon_owes_tutor).to eq nil
    end

    it "reduces axon_fee in order to pay tutor (Axon doesn't owe tutor extra in this example)" do 
      expect(@setup.charge.axon_fee).to eq 675
      context = ApplyPromoCode.call(@setup)
      expect(context.charge.axon_fee).to eq 175
    end
  end

end