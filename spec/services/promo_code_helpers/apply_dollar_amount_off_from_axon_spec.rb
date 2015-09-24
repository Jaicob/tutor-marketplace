require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::ApplyDollarAmountOffFromAxon' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::ApplyDollarAmountOffFromAxon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :dollar_amount_off_from_axon, amount: 10)
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
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::ApplyDollarAmountOffFromAxon.new(context)

      @charge = @context.charge
      @amount = @context.charge.amount
      @promotion_id = @context.promotion_id
      @promotion_discount = @context.find_promo_code_value(@promotion)
      @discount_price = @amount - @promotion_discount
      @tutor_fee = @context.tutor_fee

    end

    it "records the promotion_id on a charge with .record_promotion_id_on_charge" do 
      @context.record_promotion_id_on_charge(@charge, @promotion_id)
      expect(@charge.promotion_id).to eq @promotion_id
    end 

    it "sets is_payment_required to true with .is_payment_required?" do 
      @context.is_payment_required?
      expect(@context.is_payment_required).to eq true
    end

    it "finds the promo code's value with .find_promo_code_value" do 
      @context.find_promo_code_value(@promotion)
      expect(@promotion_discount).to eq 1000
    end

    it "finds the discount_price with .find_discount_price" do
      @context.find_discount_price(@charge, @amount, @promotion_discount)
      expect(@discount_price).to eq 1300
    end

    it "adjusts fees to cover tutor fee with method by same name" do 
      @context.adjust_fees_to_cover_tutor_fee(@discount_price, @tutor_fee)
      expect(@tutor_fee).to eq 2000
    end

  end
end