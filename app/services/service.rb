module Service
  def self.get_class(payment_service)
    processor = payment_service.downcase.titleize
    "Processor::#{processor}".constantize
  end
end