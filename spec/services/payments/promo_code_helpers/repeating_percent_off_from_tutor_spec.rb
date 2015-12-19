require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::RepeatingPercentOffFromTutor' do

  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @tutor_course = @tutor.tutor_courses.first
    @student = create(:student)
  end

  describe 'Repeating Percent Off From Tutor Promos' do

    it 'adjusts fees for a 15%-off repeating-tutor-discount for one eligible appt' do 
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
      @context = PromoCodeHelpers::RepeatingPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2248
      expect(@context.charge.tutor_fee).to eq 1955
      expect(@context.charge.axon_fee).to eq 293
    end

    it 'adjusts fees for a 15%-off repeating-tutor-discount for two eligible appts' do 
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
      @context = PromoCodeHelpers::RepeatingPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5290
      expect(@context.charge.tutor_fee).to eq 4600
      expect(@context.charge.axon_fee).to eq 690
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4496
      expect(@context.charge.tutor_fee).to eq 3910
      expect(@context.charge.axon_fee).to eq 586
    end

    it 'does not adjust fees for a 15%-off repeating-tutor-discount for a non-eligible appt' do 
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
      @context = PromoCodeHelpers::RepeatingPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end

    it 'only adjust fees for eligible appts with a 15%-off repeating-tutor-discount on a booking with both eligible and non-eligible appts' do 
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
      @context = PromoCodeHelpers::RepeatingPercentOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 5290
      expect(@context.charge.tutor_fee).to eq 4600
      expect(@context.charge.axon_fee).to eq 690
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 4893
      expect(@context.charge.tutor_fee).to eq 4254
      expect(@context.charge.axon_fee).to eq 639
    end

  end
end