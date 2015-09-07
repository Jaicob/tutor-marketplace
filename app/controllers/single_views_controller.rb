class SingleViewsController < ApplicationController

  def home
    @sign_up_path = new_tutor_path
    @search_path = search_path()
  end

  def restricted_access
  end

end
