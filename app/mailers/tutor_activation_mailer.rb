class TutorActivationMailer < ApplicationMailer
  default from: 'info@axontutors.com'

  def activation_email(user)
    @user = user
    @url = 'link to schedule...or like...whatever'
    mail(to: @user.email, subject: "Congratulations! Your Axon Tutors account has been activated")
  end

  def deactivation_email(user)
    @user = user
    @url = 'http://giphy.com/gifs/SSFB10QdOq1Gw/html5'
    mail(to: @user.email, subject: "IMPORTANT: Please sit down before reading this message from Axon Tutors")
  end

end
