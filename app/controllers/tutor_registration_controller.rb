# This controller was necessary to allow the creation of a User and Tutor in the same sign-up form
# Followed some advice from this blog post: http://kakimotonline.com/2014/03/30/extending-devise-registrations-controller/
class TutorRegistrationController < Devise::RegistrationsController

  def new
    build_resource({})
    self.resource.tutor = Tutor.new
    respond_with self.resource
  end

end
