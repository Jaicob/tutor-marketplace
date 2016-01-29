class SingleViewsController < ApplicationController

  def home
    if current_user && current_user.admin then redirect_to admin_schools_path end
    if cookies[:school_id].blank? && !@school # redirects to student_landing page if no school set
      if current_user && current_user.admin
        redirect_to admin_schools_path
      else
        redirect_to get_started_path
      end
    end
  end

  def student_landing
    if current_user && current_user.admin then redirect_to admin_schools_path end
    if current_user # this page is only for new visitors, so redirect to home if session exists
      redirect_to root_path
    end
  end

  def tutor_landing
    if current_user && current_user.admin then redirect_to admin_schools_path end
  end

  def existing_tutor_landing
    redirect_to become_a_tutor_path
    # this can eventually be removed, this action was for the existing tutor onboarding which is now over, but want to have this here for a little while longer in case any tutors eventually click on that link from the email
  end

  def search
    if current_user && current_user.admin then redirect_to admin_schools_path end
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