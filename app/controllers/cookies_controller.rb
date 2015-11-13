class CookiesController < ApplicationController
  before_action :set_tutor
  before_action :set_student
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
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    redirect_to root_path
  end

  # Sets the school from the nav dropdown school list
  def change_school_id_cookie
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
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    redirect_to :back
  end

  private

    def set_school_id
      @school_id = params[:school_id] 
    end

    def set_student
      if current_user && current_user.student
        @student = current_user.student
      end
    end

    def set_tutor
      if current_user && current_user.tutor
        @tutor = current_user.tutor
      end
    end

end