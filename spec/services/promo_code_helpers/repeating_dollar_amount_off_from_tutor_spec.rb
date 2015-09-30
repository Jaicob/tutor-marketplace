require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::RepeatingDollarAmountOffFromTutor' do
  let(:course) { create(:course) }
  let(:second_course) { create(:second_course) }



  describe 'Methods in PromoCodeServices::RepeatingDollarAmountOffFromTutor' do

    before :each do 
      @tutor = create(:tutor, :with_tutor_courses)
      course_id = @tutor.courses.first.id
      slot_id = @tutor.slots.create(start_time: "2015-09-01 10:00:00", duration: 21600).id
      @appointment = create(:appointment, slot_id: slot_id, course_id: course_id)
      @promotion = @tutor.promotions.create(code: '123', category: :repeating_dollar_amount_off_from_tutor, amount: 5, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 5, redemption_count: 0, course_id: course_id)
      tutor_course = create(:tutor_course, tutor_id: @tutor.id, course_id: course_id )
    end

    it 'adjusts fees for a $5-off repeating-tutor-discount for one eligible appt' do 
      @promotion.update(amount: 5)
      params = {
        tutor: @tutor,
        appointments: [@appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2070
      expect(@context.charge.tutor_fee).to eq 1800
      expect(@context.charge.axon_fee).to eq 270
    end

    it 'adjusts fees for a $5-off repeating-tutor-discount for two eligible appts' do 
      @promotion.update(amount: 5)
      new_slot_id = @tutor.slots.create(start_time: '2015-09-20 10:00:00', duration: 3600).id
      course_id = @promotion.course_id
      @appointment_two = create(:appointment, slot_id: new_slot_id, course_id: course_id, start_time: '2015-09-20 10:00:00')
      params = {
        tutor: @tutor,
        appointments: [@appointment, @appointment_two],
        customer_id: 1,
        token: 1111111111,
        rates: [23, 23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5290
      expect(@context.charge.tutor_fee).to eq 4600
      expect(@context.charge.axon_fee).to eq 690
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4140
      expect(@context.charge.tutor_fee).to eq 3600
      expect(@context.charge.axon_fee).to eq 540
    end

    it 'does not adjust fees for a $5-off repeating-tutor-discount for a non-eligible appt' do 
      @promotion.update(amount: 5)
      @appointment.update(course_id: second_course.id)
      params = {
        tutor: @tutor,
        appointments: [@appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end

    it 'only adjust fees for eligible appts with a $5-off repeating-tutor-discount on a booking with both eligible and non-eligible appts' do 
      @promotion.update(amount: 5)
      new_slot_id = @tutor.slots.create(start_time: '2015-09-20 10:00:00', duration: 3600).id
      course_id = @promotion.course_id
      @appointment_two = create(:appointment, slot_id: new_slot_id, course_id: second_course.id, start_time: '2015-09-20 10:00:00')
      params = {
        tutor: @tutor,
        appointments: [@appointment, @appointment_two],
        customer_id: 1,
        token: 1111111111,
        rates: [23, 23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5290
      expect(@context.charge.tutor_fee).to eq 4600
      expect(@context.charge.axon_fee).to eq 690
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4715
      expect(@context.charge.tutor_fee).to eq 4100
      expect(@context.charge.axon_fee).to eq 615
    end

  end
end