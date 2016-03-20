class ApplicationController < ActionController::Base
  # Previosuly was protected with
  # => protect_from_forgery with: :exception
  # But changed to code below to prevent CSRF protection blocking Stripe token being sent back
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # rescue_from StandardError do |e|
  #   # send error report emails for production
  #   if !request.original_url.include?('dockerhost') && !request.original_url.include?('staging')
  #     error_report = create_error_report(e)
  #     ProductionErrorMailer.delay.send_error_report('PRODUCTION', error_report)
  #   # send error report emails for staging
  #   elsif !request.original_url.include?('dockerhost')
  #     error_report = create_error_report(e)
  #     ProductionErrorMailer.delay.send_error_report('STAGING', error_report)
  #   end
  #   # (no emails sent for local)
  #   # redirect to Axon branded error page
  #   redirect_to standard_error_path
  # end

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_school

  protected

    # Devise modification
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, tutor_profile: [:extra_info, :phone_number]]
      devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
    end

    # Devise modification
    def after_sign_in_path_for(resource)
      if cookies[:checkout_login_redirect]
        checkout_review_booking_path(cookies[:checkout_login_redirect])
      else 
        case resource.role
        when 'student'
          home_student_path(resource)
        when 'tutor'
          home_tutor_path(resource.tutor.slug)
        when 'campus_manager'
          admin_school_path(resource.campus_manager.school)
        when 'admin'
          admin_schools_path
        end
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
      end
    end

    # Before_action for multiple controllers
    def set_student
      if current_user && current_user.student
        @student = current_user.student
      end
    end

    # Before_action to set school selection
    def set_school
      if current_user
        @school = current_user.school
      elsif @tutor 
        @school = School.find(@tutor.school_id)
      elsif !cookies[:school_id].blank?
        @school = School.find(cookies[:school_id].to_i)
      else
        @school = nil
      end
    end

    # Set the time_zone based off the school
    def set_time_zone(&block)
      timezone = @school.try(:timezone) || 'UTC'
      Time.use_zone(timezone, &block)
    end

    def create_error_report(e)
      error_report = {
        error: e,
        utc_time: DateTime.now,
        url: request.original_url
      }
      if current_user
        error_report[:user] = {
          name: current_user.full_name,
          role: current_user.role,
          email: current_user.email,
        }
      else
        error_report[:user] = {
          name: 'Visitor'
        }
      end
      return error_report
    end
end