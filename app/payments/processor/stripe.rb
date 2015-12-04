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
            ip: tutor.sign_in_ip
          }
        )
        tutor.update_attributes(acct_id: acct[:id])
      else
        acct = ::Stripe::Account.retrieve(tutor.acct_id)
      end
      acct.external_accounts.create(:external_account => token)
    end

    def reconcile_coupon_difference(charge)
      transfer = ::Stripe::Transfer.create(
        amount: charge.amount,
        currency: 'usd',
        destination: charge.tutor.acct_id,
        description: "Reconciliation for Coupon #{promotion.description}"
      )
    end

    def send_charge(charge)
      if charge.customer_id.nil?
        ::Stripe::Charge.create(
          amount: charge.amount,
          currency: 'usd',
          source: charge.token,
          destination: charge.tutor.acct_id,
          application_fee: charge.axon_fee
        )
      end
      # KEEP EXCESSIVE PUTS STATEMENTS HERE! This is really hard to write tests for so we're testing this bitch in the console output... \_(ツ)_/¯
      puts "SEND CHARGE METHOD IN STRIPE.RB"
      puts "charge.amount = #{charge.amount}"
      puts "charge.customer_id = #{charge.customer_id}"
      puts "charge.tutor_acct_id = #{charge.tutor.acct_id}"
      puts "charge.axon_fee = #{charge.axon_fee}"
      puts "charge.tutor_fee = #{charge.tutor_fee}"
      ::Stripe::Charge.create(
        amount: charge.amount,
        currency: 'usd',
        customer: charge.customer_id,
        destination: charge.tutor.acct_id,
        application_fee: charge.axon_fee
      )
    end

    def update_customer(student, token)
      if student.customer_id.nil?
        cust = ::Stripe::Customer.create(
          card: token,
          description: "#{student.full_name} - #{student.email}",
          email: student.email
        )
        if cust.sources['data'].first
          brand = cust.sources['data'].first['brand']
          last_4 = cust.sources['data'].first['last4']
          student.update_attributes(
            customer_id: cust.id, 
            last_4_digits: last_4,
            card_brand: brand
          )
        end
      else
        cust = ::Stripe::Customer.retrieve(student.customer_id)
        # delete old card
        cust.sources.first.delete()
        # save new card
        cust.sources.create(source: token)
        cust.save
        if cust.sources['data'].first
          brand = cust.sources['data'].first['brand']
          last_4 = cust.sources['data'].first['last4']
          student.update_attributes(
            customer_id: cust.id, 
            last_4_digits: last_4,
            card_brand: brand
          )
        end
      end
    end

    def reconcile_coupon_difference(tutor, transfer_amount, promotion)
      # transfer_amount = amount that Axon owes tutor (represented by a negative Axon fee converted to positive integer)
      transfer = ::Stripe::Transfer.create(
        amount: transfer_amount,
        currency: 'usd',
        destination: tutor.acct_id,
        description: "Reconciliation for Promo ID ##{promotion.id}"
      )
    end

  end
end