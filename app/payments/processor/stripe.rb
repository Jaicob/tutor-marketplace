require 'stripe'

module Processor
  class Stripe

    def initialize()
      # Stripe.api_key = api_key
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
      acct.external_accounts.create({ :external_account => token })
    end

    def send_charge(charge)
      Stripe::Charge.create(
        amount: charge.amount,
        currency: 'usd',
        source: charge.token || charge.customer_id,
        destination: charge.tutor.acct_id,
        application_fee: charge.transaction_fee
      )
    end

  end
end