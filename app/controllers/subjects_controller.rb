class SubjectsController < ApplicationController

  def index
    if params[:school_id]
      # all courses at a school
      courses = Course.where(school_id: params[:school_id])

      # get all unique subject ids from school courses
      subject_ids = courses.map{|course| course.subject_id }.uniq

      # look up and spit out those unique subject objects
      subjects = subject_ids.map { |subject_id| Subject.find(subject_id) }

      render json: subjects.as_json
    end
  end

  def all
    render json: Subject.all
  end

  def show
    render json: Subject.find(subject_params)
  end

  private

  def subject_params
    params.permit(:id)
  end

end
