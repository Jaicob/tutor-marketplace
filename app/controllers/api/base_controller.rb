class API::BaseController < ApplicationController
  before_action :restricted_access
  respond_to :json

  private 

    def restricted_access
      # simply restricts access to visitors, does not stop logged-in users
      # more extensive restrictions are implemented in specific controllers
      restricted_controllers = %w(SlotsController)
      restricted_controllers.each do |controller|
        if self.class.to_s.include?(controller) && !current_user
          return redirect_to restricted_access_page_path status: 401
        end
      end
    end

end