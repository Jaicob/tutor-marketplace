class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end

  def after_sign_in_path_for(resource)
    if resource.tutor
      dashboard_courses_tutor_path(resource.tutor)
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    dashboard_courses_tutor_path(resource.tutor)
  end

  def after_inactive_sign_up_path_for(resource)
    dashboard_courses_tutor_path(resource.tutor)
  end

  def set_tutor
    @tutor = Tutor.find(params[:id])
  end

  def set_user
    @user = @tutor.user
  end

end
