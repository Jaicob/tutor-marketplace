class AdminController < ApplicationController
  before_action :authorized_for_admin_area?
  before_action :set_user
  before_action :set_school

  # Add filters for restricting access to Admins only and setting current Admin user

end
