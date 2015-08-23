class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, SendPayment

end