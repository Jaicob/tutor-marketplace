class Dashboard::Admin::StudentsController < AdminController
  before_action :set_student_admin_controller, only: [:show, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:students).ransack(params[:q])
    @students_total = @q.result.includes(:user, :appointments).order(created_at: :desc)
    @students = @students_total.page(params[:page])
  end

  def new
  end

  def show
  end

  def update
    @student.update(student_params)
    if @appt.save
      redirect_to campus_manager_school_student_path(@student.school.id, @student.id)
    else
      flash[:error] = "Student was not updated."
      render :show
    end
  end

  private

    def student_params
      params.require(:student).permit(:user_id)
    end

    def set_student_admin_controller
      @student = Student.find(params[:id])
    end

end
