require 'rails_helper'

RSpec.describe CheckoutOrganizer do

  describe 'apply_promo_code interactor' do 
    
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

    context 'with free session promo code from Axon' do

      it 'creates charge correctly' do      
        @tutor_course.update(rate: 20)
        @promo = create(:promotion, :free_from_axon)
        params = {
          tutor_id: @tutor.id,
          student_id: @student.id,
          stripe_token: nil,
          appts_info: [
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
          ],
          promo_code: @promo.code
        }
        VCR.use_cassette('run_checkout_organizer_with_promo_reconciliation') do
          @context = CheckoutOrganizer.call(params)
        end
        expect(@context.success?).to eq(true)
        expect(@context.charge.tutor_id).to eq(@tutor.id)
        expect(@context.charge.student_id).to eq(@student.id)
        expect(@context.charge.amount).to eq(0)
        expect(@context.charge.axon_fee).to eq(-2000)
        expect(@context.charge.tutor_fee).to eq(2000)
        expect(@context.charge.token).to eq(nil)
        expect(@context.charge.promotion_id).to eq(@promo.id)
        expect(@context.charge.stripe_charge_id).to eq(nil)
      end
    end

    context 'with 10% off promo code from Axon' do 

      it 'creates charge correctly' do 
        @tutor_course.update(rate: 20)
        @promo = create(:promotion, :ten_percent_off_from_axon)
        params = {
          tutor_id: @tutor.id,
          student_id: @student.id,
          stripe_token: @token,
          appts_info: [
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
          ],
          promo_code: @promo.code
        }
        VCR.use_cassette('run_checkout_organizer') do
          @context = CheckoutOrganizer.call(params)
        end        
        expect(@context.success?).to eq(true)
        expect(@context.charge.tutor_id).to eq(@tutor.id)
        expect(@context.charge.student_id).to eq(@student.id)
        expect(@context.charge.amount).to eq(2070)
        expect(@context.charge.axon_fee).to eq(70)
        expect(@context.charge.tutor_fee).to eq(2000)
        expect(@context.charge.token).to eq(@token)
        expect(@context.charge.promotion_id).to eq(@promo.id)
        expect(@context.charge.stripe_charge_id).to_not eq(nil)
      end
    end

    context 'with 10% off promo code from Tutor' do

      it 'creates charge correctly' do 
        @tutor_course.update(rate: 20)
        @promo = create(:promotion, :ten_percent_off_from_tutor, tutor_id: @tutor.id)
        params = {
          tutor_id: @tutor.id,
          student_id: @student.id,
          stripe_token: @token,
          appts_info: [
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
          ],
          promo_code: @promo.code
        }
        VCR.use_cassette('run_checkout_organizer') do
          @context = CheckoutOrganizer.call(params)
        end        
        expect(@context.success?).to eq(true)
        expect(@context.charge.tutor_id).to eq(@tutor.id)
        expect(@context.charge.student_id).to eq(@student.id)
        expect(@context.charge.amount).to eq(2070)
        expect(@context.charge.axon_fee).to eq(270)
        expect(@context.charge.tutor_fee).to eq(1800)
        expect(@context.charge.token).to eq(@token)
        expect(@context.charge.promotion_id).to eq(@promo.id)
        expect(@context.charge.stripe_charge_id).to_not eq(nil)
      end
    end

    context 'with a no_repeat promo code being redeemed again' do

      it 'it correctly creates charge with no discount' do 
        @tutor_course.update(rate: 20)
        @promo = create(:promotion)
        @students_promotions = create(:students_promotions, student: @student, promotion: @promo)
        params = {
          tutor_id: @tutor.id,
          student_id: @student.id,
          stripe_token: @token,
          appts_info: [
            {slot_id: @tutor.slots.first.id, course_id: @tutor_course.course_id, start_time: @tutor.slots.first.start_time},
          ],
          promo_code: @promo.code
        }
        VCR.use_cassette('run_checkout_organizer') do
          @context = CheckoutOrganizer.call(params)
        end        
        expect(@context.success?).to eq(true)
        expect(@context.charge.tutor_id).to eq(@tutor.id)
        expect(@context.charge.student_id).to eq(@student.id)
        expect(@context.charge.amount).to eq(2300)
        expect(@context.charge.axon_fee).to eq(300)
        expect(@context.charge.tutor_fee).to eq(2000)
        expect(@context.charge.token).to eq(@token)
        expect(@context.charge.promotion_id).to eq(nil)
        expect(@context.charge.stripe_charge_id).to_not eq(nil)
      end
    end
  end
end