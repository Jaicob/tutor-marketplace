class SchoolsController < ApplicationController
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
      redirect_to schools_path
    else
      flash[:error] = "School was not created: #{@school.errors.full_messages}"
      render :new
    end
  end

  def show 
  end

  def update
    if @school.update(school_params)
      redirect_to @school
    else
      flash[:error] = "School was not updated: #{@school.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @school.destroy
      redirect_to schools_path
    else
      flash[:error] = "School was not destroyed: #{@school.errors.full_messages}"
      render :show
    end
  end

  private 

    def set_school
      @school = School.find(params[:id])
    end

    def school_params
      params.require(:school).permit(:name, :location)
    end

end