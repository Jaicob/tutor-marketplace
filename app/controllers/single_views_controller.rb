class SingleViewsController < ApplicationController

  def home
    @sign_up_path = new_tutor_path
    @search_path = search_path()
  end

  def restricted_access
  end

  def about_us
  end

  def faqs
  end

  def partnerships
  end

  def tutor_landing
  end

  def tutor_search
  end

  def contact
  end

end
