class ApplicationMailer < ActionMailer::Base
  default from: 'info@axontutors.com'
  default template_path: "mailers/#{self.name.underscore}"
end
