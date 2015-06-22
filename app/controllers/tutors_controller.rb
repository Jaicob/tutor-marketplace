class TutorsController < ApplicationController
  before_action :set_tutor, only: [:edit, :update, :register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :create_tutor_course]

  def index
    @tutors = Tutor.all
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
      redirect_to dashboard_user_path(current_user)
    else
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
    @tutor = User.find(params[:id]).tutor
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
      render :new
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
      params.require(:tutor).permit(:extra_info, :transcript)
    end

end