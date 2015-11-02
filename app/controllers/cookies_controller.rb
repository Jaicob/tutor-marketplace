class CookiesController < ApplicationController

  def set_school_id_cookie
    school_id = params[:visitor][:school_id] || params[:school_id]
    puts "COOKIE VALUE IS SCHOOL_ID = #{school_id}"
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    if current_user
      current_user.update(school_id: school_id)
    end
    redirect_to root_path
  end

end
