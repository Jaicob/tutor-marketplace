class CoursesController < ApplicationController

  def index
    courses = set_courses()
    render json: courses
  end

  private

  def course_params
    params.permit(:school_id, :subject_id, :friendly_name, :id)
  end

  def set_courses
    if params[:tutor_id]

      course_params[:tutor_id] = params[:tutor_id]

      Tutor.find(params[:tutor_id]).tutor_courses

      # get all tutor-course id pairings
      tutor_courses = TutorCourse.where(course_params)

      # merges rate from the tutor_course object with the course object
      courses = tutor_courses.map do |tutor_course|
        course = Course.find(tutor_course.course.id)
        course.attributes.merge({rate: tutor_course.rate,
                                 school_name: course.school_name,
                                 subject_name: course.subject_name})
      end
    else
      courses = Course.where(course_params)
      courses = courses.map { |course|
        course.attributes.merge({school_name: course.school_name,
                                 subject_name: course.subject_name})
      }
    end
  end

end
