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
      render :new, error: "School was not created."
    end
  end

  def show 
  end

  def edit
  end

  def update
    @school.update(school_params)

    if @school.save
      redirect_to schools_path
    else
      render :edit, error: "School was not updated."
    end
  end

  def destroy
    if @school.destroy
      redirect_to schools_path
    else
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