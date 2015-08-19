class TutorManagementMailer < ApplicationMailer
  default from: 'info@axontutors.com'
  default template_path: "mailers/#{self.name.underscore}"

  def welcome_email(tutor_id)
    @tutor = Tutor.find(tutor_id)
    @user = @tutor.user
    mail(to: @user.email, subject: "Thanks for signing up to become an Axon Tutor!")
  end

  def application_completed_email(tutor_id)
    @tutor = Tutor.find(tutor_id)
    @user = @tutor.user
    mail(to: @user.email, subject: "Way to go! You've completed your application to become an Axon Tutor")
  end

  def rejection_email(tutor_id)
    @tutor = Tutor.find(tutor_id)
    @user = @tutor.user
    mail(to: @user.email, subject: "Regarding your recent application to become an Axon Tutor")
  end

  def activation_email(tutor_id)
    @tutor = Tutor.find(tutor_id)
    @user = @tutor.user
    mail(to: @user.email, subject: "Congratulations! Your Axon Tutors account has been activated!")
  end

  def deactivation_email(user_id)
    @tutor = Tutor.find(tutor_id)
    @user = @tutor.user
    mail(to: @user.email, subject: "Your Axon Tutors account has been de-activated")
  end

end