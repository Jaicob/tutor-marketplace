class TutorsController < ApplicationController
  before_action :set_tutor, only: [:show, :edit, :update, :register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :create_tutor_course]

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
      @tutor.set_initial_tutor_course(@tutor, params)
      flash[:notice] = "Tutor account succesfully created!"
      redirect_to tutor_path(@tutor)
    else
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
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
      @tutor.set_initial_tutor_course(@tutor, params)
      flash[:notice] = "Tutor account succesfully created!"
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

    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    def tutor_params
      params.require(:tutor).permit(:extra_info, :transcript)
    end

end