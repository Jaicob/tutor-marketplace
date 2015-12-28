require 'stripe'

module Processor
  class Stripe

    def initialize()
      ::Stripe.api_key = ENV['stripe_secret_key']
    end

    def update_managed_account(tutor, token)
      if tutor.acct_id.nil?
        acct = ::Stripe::Account.create(
          managed: true,
          country: 'US',
          email: tutor.email,
          legal_entity: {
            type: "individual",
            address: {
              line1: tutor.line1,
              line2: tutor.line2,
              city: tutor.city,
              state: tutor.state,
              postal_code: tutor.postal_code
            },
            first_name: tutor.first_name,
            last_name: tutor.last_name,
            ssn_last_4: tutor.ssn_last_4,
          },
          debit_negative_balances: true,
          tos_acceptance: {
            date: Time.zone.now.to_i,
            ip: tutor.sign_in_ip || ("75.137.2.212" if Rails.env.test? || Rails.env.development?)
          }
        )
        tutor.update_attributes(acct_id: acct[:id])
      else
        acct = ::Stripe::Account.retrieve(tutor.acct_id)
      end
      acct.external_accounts.create(:external_account => token)
    end

    def send_charge(charge)
      puts "CALLLED!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      @student = Student.find(charge.student_id)

      puts "@student = #{@student}!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

      if @student.customer_id.nil?
        puts "@student.customer_id.nil? CALLLED!!!!!!!!!!!!!!!!!!!!!!!!!!!!"


        # # KEEP PUTS STATEMENTS here for manual testing!
        puts "SEND CHARGE METHOD IN STRIPE.RB"
        puts "SENDING CHARGE WITH CARD TOKEN"
        puts "charge.amount = #{charge.amount}"
        puts "charge.student_id = #{charge.student_id}"
        puts "charge.tutor_acct_id = #{charge.tutor.acct_id}"
        puts "charge.axon_fee = #{charge.axon_fee}"
        puts "charge.tutor_fee = #{charge.tutor_fee}"
        puts "charge.token = #{charge.token}"
        puts "@student.customer_id = #{@student.customer_id}"
        # # end of logs testing

        # creates charge with token if Student does not have a Stripe Customer
        stripe_charge_object = ::Stripe::Charge.create(
          amount: charge.amount,
          currency: 'usd',
          source: charge.token,
          destination: charge.tutor.acct_id,
          application_fee: charge.axon_fee
        )
        puts "stripe_charge_object !!!!!!!!! = #{stripe_charge_object}"
        return stripe_charge_object
      else
        puts "---else---- CALLLED!!!!!!!!!!!!!!!!!!!!!!!!!!!!"


        # # KEEP PUTS STATEMENTS here for manual testing!
        puts "SEND CHARGE METHOD IN STRIPE.RB"
        puts "SENDING CHARGE FROM STUDENT CUSTOMER ACCOUNT"
        puts "charge.amount = #{charge.amount}"
        puts "charge.student_id = #{charge.student_id}"
        puts "charge.tutor_acct_id = #{charge.tutor.acct_id}"
        puts "charge.axon_fee = #{charge.axon_fee}"
        puts "charge.tutor_fee = #{charge.tutor_fee}"
        puts "charge.token = #{charge.token}"
        puts "@student.customer_id = #{@student.customer_id}"
        # # end of logs testing

        # creates charge with Student's Customer and default source
        stripe_charge_object = ::Stripe::Charge.create(
          amount: charge.amount,
          currency: 'usd',
          customer: Student.find(charge.student_id).customer_id,
          destination: charge.tutor.acct_id,
          application_fee: charge.axon_fee
        )
        puts "stripe_charge_object !!!!!!!!! = #{stripe_charge_object}"
        return stripe_charge_object
      end
    end

    def update_customer(student, token)
      if student.customer_id.nil?
        # create Stripe customer
        cust = ::Stripe::Customer.create(
          card: token,
          description: "#{student.full_name} - #{student.email}",
          email: student.email
        )
        # save Stripe customer details on Student object
        student.update_attributes(
          customer_id: cust.id, 
          last_4_digits: cust.sources.data.first.last4,
          card_brand: cust.sources.data.first.brand
        )
      else
        cust = ::Stripe::Customer.retrieve(student.customer_id)
        # deletes customer's old card
        cust.sources.data.first.delete()
        # creates new card and then saves customer to refresh customer data with new card
        cust.sources.create(source: token)
        cust.save
        # updates card info on Student object
        student.update_attributes(
          last_4_digits: cust.sources.data.first.last4,
          card_brand: cust.sources.data.first.brand
        )
      end
    end

    def reconcile_coupon_difference(tutor, transfer_amount, promotion)
      # transfers $ from Axon account to a Tutor account when an Axon issued coupon results in a Student paying less that the Tutor's total fee
      # transfer_amount = amount that Axon owes tutor (value should be a positive integer)
      transfer = ::Stripe::Transfer.create(
        amount: transfer_amount,
        currency: 'usd',
        destination: tutor.acct_id,
        description: "Reconciliation for Promo ID ##{promotion.id}"
      )
    end

  end
end