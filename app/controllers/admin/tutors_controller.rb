class Admin::TutorsController < AdminController
  before_action :set_tutor, only: [:show, :update, :destroy]

  def index
    @tutors = Tutor.all
  end

  def show
  end

  def edit
  end

  def update
    if @tutor.update(tutor_params)
      redirect_to admin_tutor_path(@tutor)
    else
      flash[:error] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @tutor.destroy
      flash[:notice] = "Tutor was succesfully deleted."
      redirect_to admin_tutors_path
    else
      flash[:error] = "Tutor was not deleted: #{@tutor.errors.full_messages}"
      render :show
    end
  end

end

  private

    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    def tutor_params
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate])
    end