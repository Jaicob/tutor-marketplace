require 'rails_helper'

RSpec.describe CheckoutOrganizer do

  describe 'send_payment interactor' do 
    
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
      VCR.use_cassette('create card token for student customer creation') do
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

    context 'for a single $23 appointment' do 

      context 'with saved_card and customer_id' do

        it 'creates charge correctly' do 
          # Creates a Stripe customer for Student
          VCR.use_cassette('create_customer_with_saved_card') do
            Processor::Stripe.new.update_customer(@student, @token)
          end

          @tutor_course.update(rate: 23)

          params = {
            tutor_id: @tutor.id,
            student_id: @student.id,
            stripe_token: nil,
            appts_info: [
              {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
              {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
            ],
            promo_code: nil
          }
          VCR.use_cassette('run_checkout_organizer_with_saved_card') do
            @context = CheckoutOrganizer.call(params)
          end              
          expect(@context.success?).to eq(true)
          expect(@context.charge.tutor_id).to eq(@tutor.id)
          expect(@context.charge.student_id).to eq(@student.id)
          expect(@context.charge.amount).to eq(5290)
          expect(@context.charge.axon_fee).to eq(690)
          expect(@context.charge.tutor_fee).to eq(4600)
          expect(@context.charge.token).to eq(nil)
          expect(@context.charge.promotion_id).to eq(nil)
          expect(@context.charge.stripe_charge_id).to_not eq(nil)
        end
      end
    end
  end
end