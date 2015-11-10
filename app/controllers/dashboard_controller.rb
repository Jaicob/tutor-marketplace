class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor
  before_action :set_student

  helper DashboardNavHelper

end