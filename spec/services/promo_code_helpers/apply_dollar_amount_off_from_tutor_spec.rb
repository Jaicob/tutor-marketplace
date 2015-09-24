require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::ApplyDollarAmountOffFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::ApplyDollarAmountOffFromTutor' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :dollar_amount_off_from_tutor, amount: 10)
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
      @context = PromoCodeHelpers::ApplyDollarAmountOffFromTutor.new(context)

      @charge = @context.charge
      @amount = @context.charge.amount
      @promotion_id = @context.promotion_id
      @promotion_discount = @context.find_promo_code_value(@promotion)
      @tutor_fee = @context.tutor_fee
      @number_of_appointments = @context.rates.count
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

    it "finds the discount_tutor_fee with .calculate_discount_tutor_fee" do
      @context.calculate_discount_tutor_fee(@charge, @tutor_fee, @promotion_discount, @number_of_appointments)
      expect(@charge.tutor_fee).to eq 1000
    end

    it 'recalcuates fees with tutor_fee_discount with method by same name' do
      discount_tutor_fee = 1000
      @context.recalculate_fees_with_tutor_fee_discount(@charge, discount_tutor_fee, @context.transaction_percentage)
      expect(@context.charge.amount).to eq 1150
      expect(discount_tutor_fee).to eq 1000
      expect(@context.charge.axon_fee).to eq 150
    end

  end
end

