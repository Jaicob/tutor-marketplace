class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def home
  end

  def schedule
  end

  def courses
    @tutor_course = TutorCourse.new
  end

  def profile
  end

  def settings
  end

  # Admin actions below

  def tutors
    @tutors = Tutor.all
  end

end
