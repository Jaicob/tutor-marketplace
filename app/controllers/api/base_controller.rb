class API::BaseController < ApplicationController
  # before_action :restricted_access_controllers
  respond_to :json

  private 

    # def restricted_access_controllers
    #   # only include controllers in which there are no actions that need to be public
    #   restricted_controllers = %w()
    #   restricted_controllers.each do |controller|
    #     if self.class.to_s.include?(controller) && !current_user
    #       return redirect_to restricted_access_path, status: 401
    #     end
    #   end
    # end

end