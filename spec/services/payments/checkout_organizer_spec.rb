require 'rails_helper'

RSpec.describe CheckoutOrganizer do

  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @tutor_course = @tutor.tutor_courses.first
    @student = create(:student)
    # Creates a managed account for a Tutor
    token = Stripe::Token.create(
        :bank_account => {
        :country => "CA",
        :currency => "usd",
        :name => "Jane Austen",
        :account_holder_type => "individual",
        :routing_number => "11000000",
        :account_number => "000123456789",
      }
    )
    # Attaches managed account to a Tutor
    Processor::Stripe.new.update_managed_account(@tutor, token)
  end

  # Runs before every example
  before(:each) do 
    # Creates a card token for mock Student payment
    @token_object = Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 12,
        :exp_year => 2016,
        :cvc => "314"
      }
    )
    @token = @token_object.id
  end

  describe 'with card token, one appointment, no promotion, various prices' do

    it 'creates charge correctly for $10 session' do 
      @tutor_course.update(rate: 10)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.error).to eq nil
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(1150)
      expect(context.charge.axon_fee).to eq(150)
      expect(context.charge.tutor_fee).to eq(1000)
      expect(context.charge.token).to eq(@token)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end

    it 'creates charge correctly for $20 session' do 
      @tutor_course.update(rate: 20)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(2300)
      expect(context.charge.axon_fee).to eq(300)
      expect(context.charge.tutor_fee).to eq(2000)
      expect(context.charge.token).to eq(@token)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end

    it 'creates charge correctly for $30 session' do 
      @tutor_course.update(rate: 30)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(3450)
      expect(context.charge.axon_fee).to eq(450)
      expect(context.charge.tutor_fee).to eq(3000)
      expect(context.charge.token).to eq(@token)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end
  end

  describe 'with card token, multiple appointment, no promotion, various prices' do

    it 'creates charge correctly for two $23 sessions' do 
      @tutor_course.update(rate: 23)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
        ],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(5290)
      expect(context.charge.axon_fee).to eq(690)
      expect(context.charge.tutor_fee).to eq(4600)
      expect(context.charge.token).to eq(@token)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end

    it 'creates charge correctly for six $23 sessions' do 
      @tutor_course.update(rate: 23)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 14:00"},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 15:00"},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 16:00"},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 17:00"}
        ],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(15870)
      expect(context.charge.axon_fee).to eq(2070)
      expect(context.charge.tutor_fee).to eq(13800)
      expect(context.charge.token).to eq(@token)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end
  end

  describe 'with customer default_source' do

    it 'creates charge correctly for two $23 sessions' do 
      # Creates a Stripe customer for Student
      Processor::Stripe.new.update_customer(@student, @token)

      @tutor_course.update(rate: 23)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: nil,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
        ],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(5290)
      expect(context.charge.axon_fee).to eq(690)
      expect(context.charge.tutor_fee).to eq(4600)
      expect(context.charge.token).to eq(nil)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end
  end

  describe 'with customer default_source' do

    it 'creates charge correctly for two $23 sessions' do 
      # Creates a Stripe customer for Student
      Processor::Stripe.new.update_customer(@student, @token)

      @tutor_course.update(rate: 23)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: nil,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
        ],
        promotion_id: nil
      }
      context = CheckoutOrganizer.call(params)
      expect(context.success?).to eq(true)
      expect(context.charge.tutor_id).to eq(@tutor.id)
      expect(context.charge.student_id).to eq(@student.id)
      expect(context.charge.amount).to eq(5290)
      expect(context.charge.axon_fee).to eq(690)
      expect(context.charge.tutor_fee).to eq(4600)
      expect(context.charge.token).to eq(nil)
      expect(context.charge.promotion_id).to eq(nil)
      expect(context.charge.stripe_charge_id).to_not eq(nil)
    end
  end


end

# payment_source: card_token v. customer default_source, 
# appointments: # of appts and variable costs of each, 
# promo_codes: 8 different types, 
# emails: sending correctly?