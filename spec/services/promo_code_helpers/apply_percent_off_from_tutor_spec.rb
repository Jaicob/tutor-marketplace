require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::ApplyPercentOffFromTutor' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::ApplyPercentOffFromTutor' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :dollar_amount_off_from_tutor, amount: 50)
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
      # the CreateCharge.call isn't being tested here, but it's necessary set up (to create the charge)
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::ApplyPercentOffFromTutor.new(context)

      @charge = @context.charge
      @amount = @context.charge.amount
      @tutor_fee = @context.charge.tutor_fee
      @number_of_appointments = @context.rates.count
      @rates = @context.rates
      @transaction_percentage = @context.transaction_percentage
    end

    it "records the promotion_id on a charge with .record_promotion_id_on_charge" do 
      @context.record_promotion_id_on_charge(@charge, @promotion)
      expect(@charge.promotion_id).to eq @promotion.id
    end 

    it "sets is_payment_required to true with .is_payment_required?" do 
      @context.is_payment_required?
      expect(@context.is_payment_required).to eq true
    end

    it "gets the discount multiplier for the percentage off" do 
      @context.find_discount_multiplier_for_percent_off(@promotion)
      expect(@context.discount_multiplier).to eq 0.50
    end

    it "finds the lowest session rate (in case of multiple appts)" do 
      @context.find_lowest_rate_session(@rates)
      expect(@context.lowest_rate).to eq 20
    end

    it "finds the discount tutor_fee for a session" do 
      rate = 20
      discount_multiplier = 0.50
      @context.find_discount_rate_for_a_session(rate, discount_multiplier)
      expect(@context.discount_rate).to eq 10
    end

    it "finds the regular price for a session" do
      rate = 20
      transaction_percentage = 15
      @context.find_regular_price_for_a_session(rate, transaction_percentage)
      expect(@context.regular_session_price).to eq 23
    end

    it "finds the discount price for a session" do
      discount_rate = 10
      transaction_percentage = 15
      @context.find_discount_price_for_a_session(discount_rate, transaction_percentage)
      expect(@context.discount_session_price).to eq 11.5
    end

    it "recalculates the new amount with the one discounted session rate" do 
      regular_session_price = 2300
      discount_session_price = 1150
      @context.recalculate_amount_with_discount_price_session(@charge, @amount, regular_session_price, discount_session_price)
      expect(@context.charge.amount).to eq (4600) # bc there's still a regular price $30 session
    end

  end
end