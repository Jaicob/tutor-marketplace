# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
	:user_name => ENV['sendgrid_username'],
	:password => ENV['sendgrid_password'],
	:domain => ENV['sendgrid_domain'],
	:address => 'smtp.sendgrid.net',
	:port => 587,
	:authentication => :plain,
	:enable_starttls_auto => true
