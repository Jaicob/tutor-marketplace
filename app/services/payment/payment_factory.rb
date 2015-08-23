class PaymentFactory

  def initialize(api_key=ENV['stripe_secret_key'] )
    @api_key = api_key
  end

  def build
    Service.get_class(payment_service).new()
  end

  private

  def payment_service
    # Change this to whichever processor is being used
    return "Stripe"
  end

end