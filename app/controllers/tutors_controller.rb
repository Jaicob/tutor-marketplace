class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :update_settings, :destroy, :create_tutor_course]
  before_action :set_tutor_for_admin_or_visitor_sign_up, only: [:register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :update_active_status, :destroy_by_admin]

  # TUTOR CREATION IS HANDLED THROUGH THE DEVISE REGISTRATION CONTROLLER - ONE FORM CREATES USER AND TUTOR

  def show
  end

  def update
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    if @tutor.save
      redirect_to @tutor.update_action_redirect_path(tutor_params) # redirects to either settings or profile page
    else
      flash[:notice] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    if @tutor.destroy
      redirect_to dashboard_home_user_path(current_user)
    else
      flash[:alert] = "Your tutor account was not deleted."
      render :show
    end
  end

  #======================================================================================
  # Custom Actions for handling Tutor Account creation by visitors or non-signed in users
  #======================================================================================

  def visitor_new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def visitor_create
    @tutor = Tutor.create(tutor_params)

    if @tutor.save
      # The method below only creates a tutor_course for the initial sign-up, all other CRUD operations relating to tutor_courses go through the TutorCoursesController
      @tutor.set_first_tutor_course(@tutor, params)
      redirect_to register_or_sign_in_tutor_path(@tutor)
    else
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :visitor_new
    end
  end

  def register_or_sign_in
  end

  def visitor_sign_in
  end

  def visitor_sign_up
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
      respond_to do |format|
        format.js { render :payment_settings_updated }
      end
    else
      respond_to do |format|
        format.js { render :load_payment_form }
        flash[:error] = "Something went wrong"
      end
    end
  end

  private

    def tutor_params
<<<<<<< cae4ae0881c0d8ea26f5f4ea858d56de29b704db
      params.require(:tutor).permit(:rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
=======
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :line1, :line2, :city, :state, :postal_code, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate])
    end

    def set_tutor_for_admin_or_visitor_sign_up
      @tutor = Tutor.find(params[:id])
>>>>>>> Tutor payment settings form 90%
    end

end