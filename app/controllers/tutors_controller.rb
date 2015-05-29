class TutorsController < ApplicationController

  def new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def create
    @tutor = Tutor.create(params[:tutor_params])

    if @tutor.save
      redirect_to root_path
    else
      render :new
    end

  end


  private

    def tutor_params
      params.require(:tutor).permit(:extra_info)
    end


end
