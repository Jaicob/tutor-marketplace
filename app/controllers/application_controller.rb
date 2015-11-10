class ApplicationController < ActionController::Base
  # Previosuly was protected with
  # => protect_from_forgery with: :exception
  # But changed to code below to prevent CSRF protection blocking Stripe token being sent back
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_school_selection

  protected

    # Devise modification
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, tutor_profile: [:extra_info, :phone_number]]
      devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
    end

    # Devise modification
    def after_sign_in_path_for(resource)
      if resource.tutor
        home_tutor_path(resource)
      else
        home_student_path(resource)
      end
    end

    # Devise modification
    def after_sign_up_path_for(resource)
      if resource.tutor
        home_tutor_path(resource)
      else
        home_student_path(resource)
      end
    end

    # Devise modification
    def after_inactive_sign_up_path_for(resource)
      home_tutor_path(resource)
    end

    # Before_action for multiple controllers
    def set_user
      if current_user
        @user = User.find(current_user.id)
      else
        flash.alert = 'Please sign in to access your dashboard.'
        redirect_to new_user_session_path
      end
    end

    # Before_action for multiple controllers
    def set_tutor
      if current_user && current_user.tutor
        @tutor = current_user.tutor
      else
        @tutor = User.find(params[:id]).tutor # This sets @tutor for the show action when a user is not logged in which is necessary for visitors to see a tutor's profile
      end
    end

    # Before_action for multiple controllers
    def set_student
      if current_user.student
        @student = current_user.student
      else
        @student = nil
      end
    end

    # Before_action for multiple controllers
    def set_school
      @school = current_user.school
    end

    # Before_action for admin-area
    def set_school_for_campus_manager
      if current_user.role == 'campus_manager'
        @school = current_user.school
      end
    end

    # Before_action for admin-area
    def authorized_for_admin_area?
      # redirects to root for non-signed in users/visitors
      if !current_user
        redirect_to root_path
        return
      end
      # redirects to dashboard home for signed-in students
      if current_user.role == 'student'
        redirect_to home_student_path(current_user)
      end
      # redirects to dashboard home for signed-in tutors
      if current_user.role == 'tutor'
        redirect_to home_tutor_path(current_user)
      end
    end

    # Before_action to set school selection
    def set_school_selection
      if current_user
        @school = current_user.school
      elsif !cookies[:school_id].blank?
        @school = School.find(cookies[:school_id].to_i)
      else
        @school = nil
      end
    end

end