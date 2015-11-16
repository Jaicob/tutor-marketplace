class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor
  before_action :set_student
  before_action :onboarding_check

  helper DashboardNavHelper

  def onboarding_check
    if current_user.tutor && current_user.tutor.onboarding_status != 'Finished'
      if @tutor.onboarding_status == 'Step 1'
        redirect_to onboarding_application_tutor_path(@tutor.slug)

      elsif @tutor.onboarding_status == 'Step 2'
        redirect_to onboarding_courses_tutor_path(@tutor.slug)

      elsif @tutor.onboarding_status == 'Step 3'
        redirect_to onboarding_schedule_tutor_path(@tutor.slug)

      elsif @tutor.onboarding_status == 'Step 4'
        redirect_to onboarding_payment_details_tutor_path(@tutor.slug)
      end
    end
  end

end