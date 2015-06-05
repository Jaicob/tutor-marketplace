class DashboardController < ApplicationController
  layout "dashboard"

  def home
  end

  def schedule
  end

  def courses
    @tutor = Tutor.find(params[:id])
    @tutor_course = TutorCourse.new
    @tutor_courses = @tutor.tutor_courses
  end

  def profile
  end

  def settings
  end
end
