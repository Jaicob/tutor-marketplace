class ProductionErrorMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_error_report(env_name, error_report)
    @env_name = env_name
    @error_report = error_report
    mail(to: 'dev@axontutors.com', subject: "#{env_name} ERROR: #{@error_report['error']}")
  end

end
