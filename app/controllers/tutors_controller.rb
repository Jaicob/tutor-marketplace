class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor_for_admin_or_visitor_sign_up, only: [:register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :update_active_status, :destroy_by_admin]

  def index
    @tutors = Tutor.all
    respond_to do |format|
      format.html
      format.csv { send_data @tutors.to_csv, filename: "tutors-#{Date.today}.csv" }
    end
  end

  def new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def create
    @tutor = current_user.create_tutor(tutor_params)

    if @tutor.save
      # The method below only creates a tutor_course for the initial sign-up, all other CRUD operations relating to tutor_courses go through the TutorCoursesController
      @tutor.set_first_tutor_course(@tutor, params)
      redirect_to dashboard_home_user_path(current_user)
    else
      flash[:alert] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    # This updates everything on a tutor object, except active_status which is only editable by Admin users and which is handled in the custom update_active_status action
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    redirect_to dashboard_profile_user_path(current_user)
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
  # Custom Action for activating/de-activation and deleting Tutors by Admin users
  #======================================================================================

  def update_active_status

    respond_to do |format|
      if @tutor.update_attributes(tutor_params)
        # The following conditional send the appropriate email depending on whether a tutor was activated or de-activated
        if @tutor.active_status == 'Active'
          TutorActivationMailer.activation_email(@tutor.user).deliver_now
        else
          TutorActivationMailer.deactivation_email(@tutor.user).deliver_now
        end
        format.json { respond_with_bip(@tutor)}
      else
        format.json { respond_with_bip(@tutor)}
      end
    end
  end

  def destroy_by_admin
    if @tutor.destroy
      redirect_to dashboard_tutors_user_path(current_user)
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

  private

    def tutor_params
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate])
    end

    def set_tutor_for_admin_or_visitor_sign_up
      @tutor = Tutor.find(params[:id])
    end

end
