class Admin::StudentsController < AdminController
  before_action :set_student, only: [:show, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    @q = Student.ransack(params[:q])
    @students = @q.result.includes(:user, :appointments)
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

    def set_student
      @student = Student.find(params[:id])
    end

end

# class CampusManager::StudentsController < CampusManagerController
#   before_action :set_student, only: [:show, :update, :destroy]

#   def search
#     index
#     render :index
#   end

#   def index
#     @q = @school.students.ransack(params[:q])
#     @students = @q.result.includes(:user, :appointments)
#   end

#   def new
#   end

#   def show
#   end

#   def update
#     @student.update(student_params)
#     if @appt.save
#       redirect_to campus_manager_school_student_path(@student.school.id, @student.id)
#     else
#       flash[:error] = "Student was not updated."
#       render :show
#     end
#   end

#   private

#     def student_params
#       params.require(:student).permit(:user_id)
#     end

#     def set_student
#       @student = Student.find(params[:id])
#     end

# end
