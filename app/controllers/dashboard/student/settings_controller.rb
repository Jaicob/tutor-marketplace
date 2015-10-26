class Dashboard::Student::SettingsController < DashboardController

  def account
    # User's first_name, last_name, email and school
  end

  def payment_info
  end

  def save_payment_info
    token = params[:stripeToken]
    processor = PaymentFactory.new.build
    processor.update_customer(@student, token)
    redirect_to :back
  end

end