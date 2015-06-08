require 'rails_helper'

describe "Dashboard routing" do 
  expect(get: )
end

dashboard_user GET    /users/:id/dashboard(.:format)            dashboard#home
#             schedule_user GET    /users/:id/schedule(.:format)             dashboard#schedule
#              courses_user GET    /users/:id/courses(.:format)              dashboard#courses
#              profile_user GET    /users/:id/profile(.:format)              dashboard#profile
#             settings_user GET    /users/:id/settings(.:format)             dashboard#settings
#                           POST   /users/:id/profile(.:format)              dashboard#apply_profile
#                           POST   /users/:id/settings(.:format)             dashboard#apply_settings
#                     users GET    /users(.:format)                          users#index


home
schedule
courses
profile
update_profile
settings
update_settings

class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor

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

  def apply_profile
    if @tutor.update_attributes(tutor_params)
      redirect_to profile_tutor_path(@tutor.id)
    else
      redirect_to profile_tutor_path(@tutor.id), notice: "Error saving changes."
    end
  end

  def settings
  end

  def apply_settings
    if @user.update_attributes(user_params) && @tutor.update_attributes(tutor_params)
      redirect_to settings_tutor_path(@tutor.id)
    else
      redirect_to settings_tutor_path(@tutor.id), notice: "Error saving changes."
    end
  end