class Dashboard::SettingsController < DashboardController

  def account_settings
    # User's first_name, last_name and email
  end

  def appointment_history
    # User's appointment history
  end

  def private_information
    # Tutor's birthdate, phone_number and transcript
  end

  def profile_settings
    # Tutor's profile_pic, degree, major, graduation_year and extra_information
  end

  def appointment_settings
    # Tutor's personal note to students upon booking (also future restrictions, i.e. reservation min/max, cut-off time for bookings, etc.)
  end

  def tutor_payment_settings
    # Payment forms for Tutor to recieve funds
  end

  def payment_settings
    @tutor = User.find(params[:id]).tutor
  end

end