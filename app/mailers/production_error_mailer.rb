class ProductionErrorMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_error_report(error)
    @error = error
    mail(to: @user.email, subject: "PRODUCTION ERROR: #{@error.full_messages.first}")
  end

end
