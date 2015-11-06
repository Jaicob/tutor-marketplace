class CookiesController < ApplicationController

  def set_school_id_cookie
    # this sets the school from the form on the student_landing page
    school_id = params[:visitor][:school_id]
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    if current_user
      current_user.update(school_id: school_id)
    end
    redirect_to root_path
  end

  def change_school_id_cookie
    # this sets the school from the nav dropdown school list
    school_id = params[:school_id]
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    if current_user
      current_user.update(school_id: school_id)
    end
    redirect_to root_path
  end

end
