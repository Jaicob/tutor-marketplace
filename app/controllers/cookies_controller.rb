class CookiesController < ApplicationController
  before_action :set_tutor_for_cookies_controller
  before_action :set_student_for_cookies_controller
  before_action :set_school_id

  # Sets the school from the form on the student_landing page
  def set_school_id_cookie
    school_id = params[:school_id]
    if @tutor
      if @tutor.school_change_allowed?
        @tutor.update(school_id: school_id)
      else
        redirect_to :back
        flash[:alert] = "You cannot switch your campus with active course listings at your current campus."
        return
      end
    elsif @student
      @student.update(school_id: school_id)
    end
    cookies[:school_id] = { value: @school_id, expires: 2.months.from_now }
    redirect_to root_path
  end

  # Sets the school from the nav dropdown school list
  def change_school_id_cookie
    school_id = params[:school_id] || params[:change_school][:school_id]
    if @tutor
      if @tutor.school_change_allowed?
        @tutor.update(school_id: school_id)
        cookies[:school_id] = { value: @school_id, expires: 2.months.from_now }
        redirect_to :back
      else
        flash[:alert] = "You cannot switch your campus with active course listings at your current campus."
        redirect_to :back
      end
    elsif @student
      if @student.update(school_id: school_id)
        cookies[:school_id] = { value: @school_id, expires: 2.months.from_now }
        redirect_to :back
      else
        flash[:alert] = "School change failed: #{@student.errors.full_messages.first}"
        redirect_to :back
      end
    end
  end

  private

    def set_school_id
      if params[:visitor]
        @school_id = params[:visitor][:school_id] # params structure for visitors
      else
        @school_id = params[:school_id] # params structure for logged in users
      end
    end

    def set_student_for_cookies_controller # set_student exists in application_controller.rb
      if current_user && current_user.student
        @student = current_user.student
      end
    end

    def set_tutor_for_cookies_controller # set_tutor exists in application_controller.rb
      if current_user && current_user.tutor
        @tutor = current_user.tutor
      end
    end

end