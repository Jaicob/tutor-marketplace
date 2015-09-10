class UpdateTutorAccount
  include Interactor

  def call
    processor = PaymentFactory.new().build
    response = processor.update_managed_account(context.tutor, context.token)
  end

end