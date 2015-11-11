class Admin::SchoolsController < AdminController
  before_action :set_working_school, only: [:show, :edit, :update, :destroy, :edit_campus_manager, :update_campus_manager]
  before_action :set_campus_manager, only: [:show, :edit, :update, :destroy, :edit_campus_manager, :update_campus_manager]

  def index
    @schools = School.all
  end

  def new
    @working_school = School.new
  end

  def create
    @working_school = School.create(school_params)

    if @working_school.save
      redirect_to admin_school_path(@school)
    else
      flash[:error] = "School was not created: #{@school.errors.full_messages}"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @working_school.update(school_params)
      redirect_to admin_school_path(@working_school)
    else
      flash[:error] = "School was not updated: #{@school.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @working_school.destroy
      redirect_to admin_schools_path
    else
      render :show
    end
  end

  def edit_campus_manager
  end

  def update_campus_manager
    @campus_manager.update(campus_manager_params)
    redirect_to admin_school_path(@working_school)
  end

  private

    def set_working_school
      @working_school = School.find(params[:id])
    end

    def set_campus_manager
      @campus_manager = @working_school.campus_manager 
    end

    def school_params
      params.require(:school).permit(:name, :location, :transaction_percentage, :campus_pic)
    end

    def campus_manager_params
      params.require(:campus_manager).permit(:user_id, :phone_number, :profile_pic)
    end

end