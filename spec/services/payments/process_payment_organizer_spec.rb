require 'rails_helper'

RSpec.describe ProcessPayment do
  let(:tutor)       { create(:tutor) }
  let(:appointment) { create(:appointment) }

  describe 'ProcessPayment Organizer' do

    before :each do 
      @tutor = create(:tutor, :with_tutor_courses)
      @tutor.update(acct_id: 'acct_16lhkDFkeZWeIXFz')
      course_id = @tutor.courses.first.id
      slot_id = @tutor.slots.create(start_time: "2015-09-01 10:00:00", duration: 21600).id
      @appointment = create(:appointment, slot_id: slot_id, course_id: course_id)
      @promotion = @tutor.promotions.create(code: '123', category: :free_from_axon, amount: 0, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 5, redemption_count: 0, course_id: course_id)
      tutor_course = create(:tutor_course, tutor_id: @tutor.id, course_id: course_id, rate: 23)
    end

    it 'adjusts fees for a 15%-off repeating-tutor-discount for one eligible appt' do 
      params = {
        tutor: @tutor,
        appointments: [@appointment],
        customer_id: 'cus_79ri4tclCLRhdh',
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id
      }
      context = ProcessPayment.call(params)

      expect(context.charge.amount).to eq 2645
      expect(context.charge.tutor_fee).to eq 2300
      expect(context.charge.axon_fee).to eq 345
      context.return_adjusted_fees
      expect(context.charge.amount).to eq 2248
      expect(context.charge.tutor_fee).to eq 1955
      expect(context.charge.axon_fee).to eq 293
    end
  end
end