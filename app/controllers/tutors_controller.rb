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
    puts "Tutor params = #{tutor_params}"
    puts "Params = #{params}"
    @tutor = Tutor.create(tutor_params)

    if @tutor.save
      redirect_to tutor_path(@tutor)
    else
      render :new
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end



  private

    def tutor_params
      params.require(:tutor).permit(:extra_info, :transcript)
    end


end
