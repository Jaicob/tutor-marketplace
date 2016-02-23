module StripeDashboardLinksHelper

  def stripe_charge_link(charge_id)
    "https://dashboard.stripe.com/payments/" + charge_id
  end

  def stripe_account_link(account_id)
    "https://dashboard.stripe.com/applications/users/" + account_id
  end

end