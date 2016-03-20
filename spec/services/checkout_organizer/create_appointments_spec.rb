require 'rails_helper'

RSpec.describe CheckoutOrganizer do
  let(:cart) { create(:cart) }

  describe 'create_appointments interactor' do 
    
    # Runs once before all examples
    before(:all) do
      @tutor = create(:tutor, :with_tutor_course_and_slot)

      # Creates a managed account for a Tutor
      VCR.use_cassette('get bank_account token for tutor') do
        @token = Stripe::Token.create(
            :bank_account => {
            :country => "CA",
            :currency => "usd",
            :name => "Jane Austen",
            :account_holder_type => "individual",
            :routing_number => "11000000",
            :account_number => "000123456789",
          }
        )
      end

      # Attaches managed account to a Tutor
      VCR.use_cassette('create managed account with bank_account token') do
        Processor::Stripe.new.update_managed_account(@tutor, @token.id)
      end
    end

    # Runs before every example
    before(:each) do 
      # Creates a card token for mock Student payment
      VCR.use_cassette('create card token for student payment') do
        @token_object = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 12,
            :exp_year => 2016,
            :cvc => "314"
          }
        )
      end
      @token = @token_object.id
      @student = create(:student)
      @tutor_course = @tutor.tutor_courses.first
    end

    ####
    #
    # Setup work above - Tests begin below
    #
    ###

    context 'with duplicate appointment info supplied' do

      it 'only creates one appointment' do 
        @tutor_course.update(rate: 10)
        expect(Appointment.count).to eq 0
        params = {
          tutor_id: @tutor.id,
          student_id: @student.id,
          stripe_token: @token,
          appts_info: [
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time}
          ],
          promo_code: nil,
          cart_id: cart.id,
        }
        VCR.use_cassette('run_checkout_organizer') do
          @context = CheckoutOrganizer.call(params)
        end            
        expect(@context.error.to_s).to eq "Appointment was not created: Start time is already booked"
        expect(@context.success?).to eq(false)
        expect(@context.failure?).to eq(true)
        expect(Appointment.count).to eq 1
      end
    end
  end
end