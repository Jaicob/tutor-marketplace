class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
  end

  def after_sign_in_path_for(resource)
    dashboard_home_user_path(resource)
  end

  def after_sign_up_path_for(resource)
    dashboard_home_user_path(resource)
  end

  def after_inactive_sign_up_path_for(resource)
    dashboard_home_user_path(resource)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_tutor
    if @user
      @tutor = @user.tutor
    else
      @tutor = User.find(params[:id]).tutor # This sets @tutor for the show action when a user is not logged in which is necessary for visitors to see a tutor's profile
    end
  end

  def set_school_for_campus_manager
    if current_user.role == 'campus_manager'
      @school = current_user.school
    end
  end

  def authorized_for_admin_area?
    # redirects to root for non-signed in users/visitors
    if !current_user 
      redirect_to root_path
      return
    end
    # redirects to root for signed-in users
    if current_user.role == 'student' || current_user.role == 'tutor'
      redirect_to dashboard_home_user_path(current_user)
    end
  end

end
