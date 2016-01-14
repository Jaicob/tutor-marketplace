class ExistingTutorMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    mail(to: @user.email, subject: "Thanks for Signing In to the New Axon")
  end

  def activation_email(user_id)
    @user = User.find(user_id)
    @tutor = @user.tutor
    mail(to: @user.email, subject: "Hooray! Your New Axon Profile Is Live")
  end

end