require 'rails_helper'

RSpec.describe ProcessPayment do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'checkout with a free_from_axon promo code' do
    before :each do
      @promotion = create(:promotion, category: :free_from_axon)
      params = {
        tutor: tutor,
        appointments: [appointment],
        customer_id: 1,
        token: 789867877868,
        rates: [30],
        transaction_percentage: 17.5,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      @context = ProcessPayment.call(params)
    end 

    it 'sets context.is_payment_required to false' do
      expect(@context.is_payment_required).to eq(false)
    end

    it 'assigns the promotion_id to charge.promotion_id' do 
      expect(@context.charge.promotion_id).to eq(@promotion.id)
    end
  end
end