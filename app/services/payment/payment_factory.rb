class PaymentFactory

  def initialize(charge_id:)
    @charge_id = charge_id
  end

  def build
    Service.get_class(payment_service).new(charge: charge)
  end

  private

  def payment_service
    # Change this to whichever processor is being used
    return "Stripe"
  end

  def charge
    @charge ||= Charge.find(@charge_id)
  end

end