class TutorsController < ApplicationController

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

    if @tutor.save
      if @tutor.user_exists(@tutor)
        flash[:notice] = "Tutor account succesfully created!"
        redirect_to tutor_path(@tutor)
      else
        redirect_to new_user_registration_path
        falsh[:notice] = "Tutor account created, now make a user account to access your Dashboard!"
      end
    else
      flash[:error] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end

  def courses
    @tutor_courses = Tutor.find(params[:id]).courses
  end




  private

    def tutor_params
      params.require(:tutor).permit(:extra_info, :transcript)
    end

end

