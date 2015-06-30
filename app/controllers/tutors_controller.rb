class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :destroy, :create_tutor_course]

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
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @tutor = Tutor.find(@tutor.verify_tutor(@tutor.id, params))

    respond_to do |format|
      if @tutor.update_attributes(tutor_params)
        # format.html { redirect_to(@tutor.redirect_path, notice: 'Tutor was succesfully updated.')}
        format.json { respond_with_bip(@tutor)}
      else
        # format.html { render :edit, error: 'Tutor was not updated.'}
        format.json { respond_with_bip(@tutor)}
      end
    end
  end

  def destroy
    # @tutor = Tutor.find(params[:id]) || @tutor

    if @tutor.destroy
      redirect_to dashboard_home_user_path(@user)
    else
      render :show, error: 'Your tutor account was not deleted.'
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
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status)
    end

end