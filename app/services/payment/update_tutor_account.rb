class UpdateTutorAccount
  include Interactor

  def call
    begin 
      processor = PaymentFactory.new().build
      response = processor.update_managed_account(context.tutor, context.token)
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

end