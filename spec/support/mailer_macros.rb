module MailerMacros

  def emails
    ActionMailer::Base.deliveries
  end

  def email_addresses
    addresses = []
    ActionMailer::Base.deliveries.each do |email|
      addresses << email.to
    end
    addresses
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

end