class Admin::SchoolsController < AdminController
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def create
    @school = School.create(school_params)

    if @school.save
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
    if @school.update(school_params)
      redirect_to admin_school_path(@school)
    else
      flash[:error] = "School was not updated: #{@school.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @school.destroy
      redirect_to admin_schools_path
    else
      render :show
    end
  end

  private

    def set_school
      @school = School.find(params[:id])
    end

    def school_params
      params.require(:school).permit(:name, :location, :transaction_percentage)
    end

end