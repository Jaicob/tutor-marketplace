class SingleViewsController < ApplicationController

  def home
    if cookies[:school_id].blank? && !@school
      redirect_to get_started_path
    # else
    #   @sign_up_path = new_tutor_path
    #   @search_path = search_path()
    end
  end

  def student_landing
    if current_user 
      redirect_to root_path
    end
  end

  def tutor_landing
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