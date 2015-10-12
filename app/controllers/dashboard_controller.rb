class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_school
  before_filter :set_tutor
  before_action :set_student

  helper DashboardNavHelper
  helper IncompleteProfileProgressBarHelper

end
