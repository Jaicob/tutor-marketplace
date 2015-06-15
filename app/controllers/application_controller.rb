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
    dashboard_user_path(resource)
  end

  def after_sign_up_path_for(resource)
    dashboard_user_path(resource)
  end

  def after_inactive_sign_up_path_for(resource)
    dashboard_user_path(resource)
  end

  def set_user
    @user = User.friendly.find(current_user.id)
  end

  def set_tutor
    @tutor = @user.tutor || nil
  end

end
