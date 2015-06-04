class TutorsController < ApplicationController
  before_action :set_tutor, only: [:show, :edit, :update, :register_or_sign_in, :visitor_sign_in, :visitor_sign_up]

  def index
    @tutors = Tutor.all
  end

  def new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def create
    @tutor = Tutor.create(tutor_params)
    @tutor.set_tutor_course(@tutor, params)

    if @tutor.save
      redirect_to tutor_path(@tutor)
    else
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end

  #=============================================
  # Custom Actions
  #=============================================

  def visitor_new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def visitor_create
    @tutor = Tutor.create(tutor_params)
    @tutor.set_tutor_course(@tutor, params)

    if @tutor.save
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

  def courses
    @tutor_courses = Tutor.find(params[:id]).courses
  end


  private

    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    def tutor_params
      params.require(:tutor).permit(:extra_info, :transcript)
    end

end

