class Dashboard::Admin::SchoolsController < AdminController
  before_action :set_working_school, only: [:show, :update, :destroy]
  before_action :set_campus_manager, only: [:show, :update, :destroy]
  before_action :get_time_zones, only: [:new, :show]

  def index
    @schools = School.all
    if current_user.role == 'campus_manager'
      redirect_to admin_school_path(current_user.school)
    end
  end

  def new
    @working_school = School.new
  end

  def create
    @working_school = School.create(school_params)

    if @working_school.save
      redirect_to admin_school_path(@working_school)
    else
      flash[:error] = "School was not created: #{@school.errors.full_messages}"
      render :new
    end
  end

  def show
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

  private

    def set_working_school
      @working_school = School.find(params[:id])
    end

    def set_campus_manager
      @campus_manager = @working_school.campus_manager 
    end

    def get_time_zones
      @timezones = []

      ActiveSupport::TimeZone.us_zones.each do |zone|
        @timezones << zone.name
      end

      return @timezones
    end 

    def school_params
      params.require(:school).permit(:name, :location, :timezone, :transaction_percentage, :campus_pic)
    end

end