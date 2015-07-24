class Admin::TutorsController < AdminController

  def index
    @tutors = Tutor.all
  end

end
