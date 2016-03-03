class ProductionErrorMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_error_report(error)
    @error = error
    mail(to: 'dev@axontutors.com', subject: "PRODUCTION ERROR: #{@error}")
  end

end
