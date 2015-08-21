class TutorRegistrationController < Devise::RegistrationsController

  def new
    build_resource({})
    self.resource.tutor = Tutor.new
    self.resource.tutor.tutor_courses.new = TutorCourse.new
    respond_with self.resource
  end

end
