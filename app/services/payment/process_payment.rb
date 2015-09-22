class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, ApplyPromoCode, SendPayment
  # , SendEmails

end