require 'stripe'

module Payment
  class Stripe

    def initialize(api_key)
      Stripe.api_key = api_key
    end

    def create_managed_account(tutor)
      Stripe::Account.create(
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
          dob: tutor.birthdate,
          ssn_last_4: tutor.ssn_last_4,
        },
        debit_negative_balances: true,
        tos_acceptance: {
          date: Time.zone.now,
          ip: tutor.ip
        }
      )
    end

  end
end