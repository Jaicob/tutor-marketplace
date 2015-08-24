class TutorManagementMailer < ApplicationMailer
  default from: 'info@axontutors.com'
  default template_path: "mailers/#{self.name.underscore}"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    @user = @tutor.user
    mail(to: @user.email, subject: "Thanks for signing up to become an Axon Tutor!")
  end

  def application_completed_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    @user = @tutor.user
    mail(to: @user.email, subject: "Way to go! You've completed your application to become an Axon Tutor")
  end

  def rejection_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    @user = @tutor.user
    mail(to: @user.email, subject: "Regarding your recent application to become an Axon Tutor")
  end

  def activation_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    @user = @tutor.user
    mail(to: @user.email, subject: "Your Axon Tutors account has been activated!")
  end

  def deactivation_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    @user = @tutor.user
    mail(to: @user.email, subject: "Your Axon Tutors account has been de-activated")
  end

end