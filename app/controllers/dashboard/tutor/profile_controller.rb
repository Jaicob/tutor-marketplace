class Dashboard::Tutor::ProfileController < DashboardController

  def index
    @tutor_analyzer = TutorAnalyzer.new(@tutor)
  end
  
end
