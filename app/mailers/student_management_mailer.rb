class StudentManagementMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @student = @user.student
    mail(to: @user.email, subject: "Yay! You’ve set up your Axon Account!")
  end

end