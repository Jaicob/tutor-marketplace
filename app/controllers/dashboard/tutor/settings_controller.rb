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

  def tutor_payment
    @tutor = User.find(params[:id]).tutor
  end

  def tutor_payment_info_form
    @tutor = Tutor.find(params[:id])
    respond_to do |format|
      format.js { render :load_payment_form }
    end
  end

  def update_tutor_payment_info
    @tutor = Tutor.find(params[:id])
    if @tutor.update_attributes(tutor_params)
      @tutor.update_attributes(last_4_acct: params[:last_4_acct])
      UpdateTutorAccount.call(tutor: @tutor, token: params[:stripeToken])
      respond_to do |format|
        format.js { render :payment_settings_updated }
        format.html { redirect_to tutor_payment_settings_dashboard_user(@tutor.slug) }
      end
    else
      respond_to do |format|
        format.js { render :load_payment_form }
        flash[:error] = "Something went wrong"
      end
    end
  end

end
