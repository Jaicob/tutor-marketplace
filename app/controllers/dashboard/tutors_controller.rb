class Dashboard::TutorsController < DashboardController

  def index
    @tutors = Tutor.all
  end

end
