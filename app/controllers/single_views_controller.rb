class SingleViewsController < ApplicationController

  def home
    if cookies[:school_id].blank? && !@school # redirects to student_landing page if no school set
      if current_user && current_user.admin
        return # cancels redirect for signed-in admin, which are not supposed to have a school_id
      else
        redirect_to get_started_path
      end
    end
  end

  def student_landing
    if current_user # this page is only for new visitors, so redirect to home if session exists
      redirect_to root_path
    end
  end

  def tutor_landing
  end

  def existing_tutor_landing
    redirect_to become_a_tutor_path
  end

  def search
    if params[:course_id]
      @course = Course.find(params[:course_id])
      @subject = @course.subject
    end
    if @school.nil?
      redirect_to get_started_path
    end
  end

  def about_us
  end

  def faqs
  end

  def partners
  end

  def contact
  end
  
  def privacy_and_terms
  end
  
  def restricted_access
  end

  def error_rescue
  end

end