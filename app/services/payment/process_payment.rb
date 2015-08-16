class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, SendPayment, NotifyTutor, NotifyStudent

end