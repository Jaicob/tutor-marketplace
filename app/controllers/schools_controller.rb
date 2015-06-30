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

  def update
    respond_to do |format|
      if @school.update_attributes(school_params)
        # format.html { redirect_to(@school, notice: 'School was succesfully updated.')}
        # I don't think the html response is necessary since we are relying on online in-line editing, I deleted the edit action and template to simplify things. Just wanted to make a note to go over this with the team and discuss if this is OK to simplify like this.
        format.json { respond_with_bip(@school)}
      else
        # format.html { render :edit}
        format.json { respond_with_bip(@school)}
      end
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