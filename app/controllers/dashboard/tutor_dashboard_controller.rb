class TutorDashboardController < DashboardController
  before_action :set_tutor
  helper IncompleteProfileProgressBarHelper
end