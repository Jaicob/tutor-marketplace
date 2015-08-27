class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor
  before_action :set_school
  
  helper DashboardNavHelper
  helper IncompleteProfileProgressBarHelper

end
