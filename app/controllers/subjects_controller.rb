class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.create(subject_params)

    if @subject.save
      redirect_to subjects_path
    else
      render :new, error: "subject was not created."
    end
  end

  def show 
  end

  def edit
  end

  def update
    @subject.update(subject_params)

    if @subject.save
      redirect_to subjects_path
    else
      render :edit, error: "subject was not updated."
    end
  end

  def destroy
    if @subject.destroy
      redirect_to subjects_path
    else
      render :show
    end
  end

  private 

    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:name)
    end

end