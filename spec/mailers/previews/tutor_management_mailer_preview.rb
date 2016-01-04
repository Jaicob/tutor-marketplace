class TutorManagementMailerPreview < ActionMailer::Preview

  def welcome_email
    TutorManagementMailer.welcome_email(User.last.id)
  end

  def deactivation_email
    TutorManagementMailer.deactivation_email(User.last.id)
  end

  def application_completed_email
    TutorManagementMailer.application_completed_email(User.last.id)
  end

  def activation_email
    TutorManagementMailer.activation_email(User.last.id)
  end

end