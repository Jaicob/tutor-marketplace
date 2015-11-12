class CookiesController < ApplicationController

  def set_school_id_cookie
    # this sets the school from the form on the student_landing page
    school_id = params[:visitor][:school_id]
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    if current_user && current_user.tutor
      current_user.tutor.update(school_id: school_id)
    elsif current_user && current_user.student
      current_user.student.update(school_id: school_id)
    end
    redirect_to root_path
  end

  def change_school_id_cookie
    # this sets the school from the nav dropdown school list
    school_id = params[:school_id]
    cookies[:school_id] = { value: school_id, expires: 2.months.from_now }
    if current_user.tutor
      if current_user.tutor.courses.count > 0
        # NEED SOME SORT OF ALERT HERE!
        redirect_to :back
        return # tutor can't change to a different school if tutor has courses at current school
      end
      current_user.tutor.update(school_id: school_id)
    elsif
      current_user.student.update(school_id: school_id)
    end
    redirect_to :back
  end

end
