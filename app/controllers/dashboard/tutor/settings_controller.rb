class Dashboard::Tutor::SettingsController < DashboardController

  def account
    # User's first_name, last_name, email and school
  end

  def appointment_history
    # User's appointment history
  end

  def private_info
    # Tutor's birthdate, phone_number and transcript
  end

  def edit_profile
    # Tutor's profile_pic, degree, major, graduation_year and extra_information
  end

  def appointment_settings
    # Tutor's personal note to students upon booking (also future restrictions, i.e. reservation min/max, cut-off time for bookings, etc.)
  end

  def payment_info
    @tutor = User.find(params[:id]).tutor
  end

  def edit_address
  end

end