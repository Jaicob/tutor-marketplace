class UpdateTutorAccount
  include Interactor

  def call
    processor = PaymentFactory.new().build
    response = processor.create_managed_account(context.tutor, context.token)
  end

end