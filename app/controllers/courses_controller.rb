class CoursesController < ApplicationController

  def index
    if params[:tutor_id]

      course_params[:tutor_id] = params[:tutor_id]

      # get all tutor-course id pairings
      tutor_courses = TutorCourse.where(course_params)

      # merges rate from the tutor_course object with the course object
      courses = tutor_courses.map do |tutor_course|
        course = Course.find(tutor_course.course.id)
        course.attributes.merge({rate: tutor_course.rate,
                                 school_name: course.school_name,
                                 subject_name: course.subject_name})
      end

      render json: courses
    else
      courses = Course.where(course_params)
      courses = courses.map { |course|
        course.attributes.merge({school_name: course.school_name,
                                 subject_name: course.subject_name})
      }
      render json: courses
    end
  end

  private

  def course_params
    params.permit(:school_id, :subject_id, :friendly_name, :id)
  end

end
