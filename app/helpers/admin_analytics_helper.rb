module AdminAnalyticsHelper

  # used to quickly view records in Stripe dashboard
  def stripe_charge_link(charge_id)
    "https://dashboard.stripe.com/payments/" + charge_id
  end

  # used to quickly view records in Stripe dashboard
  def stripe_account_link(account_id)
    "https://dashboard.stripe.com/applications/users/" + account_id
  end

  # used to quickly view records in Stripe dashboard
  def stripe_customer_link(customer_id)
    "https://dashboard.stripe.com/customers/" + customer_id
  end



  # used for formatting in Students section
  def list_courses(courses_collection)
    courses_collection.each do |course|

    end
  end
end