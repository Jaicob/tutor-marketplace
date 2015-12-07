class Dashboard::Student::SettingsController < DashboardController

  def account
    # User's first_name, last_name, email and school
  end

  def payment_info
  end

  def save_payment_info
    token = params[:stripeToken]
    processor = PaymentFactory.new.build
    processor.save_default_card(@student, token)
    redirect_to payment_info_student_path
  end

  def edit_payment_info
  end

end