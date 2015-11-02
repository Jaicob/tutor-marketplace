class SingleViewsController < ApplicationController

  def home
    if cookies[:school_id].nil?
      redirect_to get_started_path
    else
      @sign_up_path = new_tutor_path
      @search_path = search_path()
    end
  end

  def student_landing
  end

  def tutor_landing
  end

  def search
  end

  def about_us
  end

  def faqs
  end

  def partners
  end

  def contact
  end

  def terms_and_conditions
  end

  def privacy_policy
  end
  
  def restricted_access
  end

  def error_rescue
  end

end