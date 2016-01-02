class TutorManagementMailerPreview < ActionMailer::Preview
  def welcome_email
    TutorManagementMailer.welcome_email(User.last.id)
  end
end