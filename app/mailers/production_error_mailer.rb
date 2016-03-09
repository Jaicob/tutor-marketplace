class ProductionErrorMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_error_report(error_report)
    @error_report = error_report
    mail(to: 'dev@axontutors.com', subject: "PRODUCTION ERROR: #{@error_report['error']}")
  end

end
