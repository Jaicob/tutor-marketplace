require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::ApplyPercentOffFromAxon' do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'Methods in PromoCodeServices::ApplyPercentOffFromAxon' do
    
    before :each do

      # Do not change inputs in this before_action, or tests may break
      @promotion = create(:promotion, category: :dollar_amount_off_from_tutor, amount: 25)
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
      @context = PromoCodeHelpers::ApplyPercentOffFromAxon.new(context)

      @charge = @context.charge
      @amount = @context.charge.amount
      @promotion_id = @context.promotion_id
      @tutor_fee = @context.tutor_fee
      @rates = @context.rates
      @number_of_appointments = @context.rates.count
      @transaction_percentage = @context.transaction_percentage
    end

    it "records the promotion_id on a charge with .record_promotion_id_on_charge" do 
      @context.record_promotion_id_on_charge(@charge, @promotion_id)
      expect(@charge.promotion_id).to eq @promotion_id
    end 

    it "sets is_payment_required to true with .is_payment_required?" do 
      @context.is_payment_required?
      expect(@context.is_payment_required).to eq true
    end

    it "gets the discount multiplier for the percentage off" do 
      @context.find_discount_multiplier_for_percent_off(@promotion)
      expect(@context.discount_multiplier).to eq 0.75
    end

    it "finds the lowest session rate (in case of multiple appts)" do 
      @context.find_lowest_rate_session(@rates)
      expect(@context.lowest_rate).to eq 20
    end

    it "finds the regular price for the lowest rate session" do
      rate = 20 
      @context.find_regular_price_for_a_session(rate, @transaction_percentage)
      expect(@context.regular_session_price).to eq 23
    end

    it "finds the discount price for the lowest rate session" do
      rate = 20
      discount_multiplier = 0.75 
      @context.find_discount_price_for_a_session(rate, @transaction_percentage, discount_multiplier)
      expect(@context.discount_session_price).to eq 17.25
    end

    it "recalculates the new amount with the one discounted session rate" do 
      regular_session_price = 2300
      discount_session_price = 1725
      @context.recalculate_amount_with_discount_price_session(@charge, @amount, regular_session_price, discount_session_price)
      expect(@context.charge.amount).to eq (5175) # bc there's still a regular price $30 session
    end

    it

    #     def recalculate_amount_with_discount_price_session(charge, amount, regular_session_price, discount_session_price)
    #    new_amount = amount - regular_session_price + discount_session_price
    #    charge.update(amount: new_amount)
    # end


    # def find_regular_price_for_a_session(rate, transaction_percentage)
    #   transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
    #   @regular_session_price = lowest_rate * transaction_fee
    # end

    # def find_discount_price_for_a_session(rate, transaction_percentage, discount_multiplier)
    #   transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
    #   @discount_session_price = lowest_rate * transaction_percentage * discount_multiplier
    # end


    # it "finds the discount_tutor_fee with .calculate_discount_tutor_fee" do
    #   @context.calculate_discount_tutor_fee(@charge, @tutor_fee, @promotion_discount, @number_of_appointments)
    #   expect(@charge.tutor_fee).to eq 1000
    # end

    # it 'recalcuates fees with tutor_fee_discount with method by same name' do
    #   discount_tutor_fee = 1000
    #   @context.recalculate_fees_with_tutor_fee_discount(@charge, discount_tutor_fee, @context.transaction_percentage)
    #   expect(@context.charge.amount).to eq 1150
    #   expect(discount_tutor_fee).to eq 1000
    #   expect(@context.charge.axon_fee).to eq 150
    # end

  end
end