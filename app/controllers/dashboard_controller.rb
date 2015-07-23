class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor
  
  helper DashboardNavHelper

end
