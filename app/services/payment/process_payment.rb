class CheckoutOrganizer
  include Interactor::Organizer

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)

  organize CreateAppointments, CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails

end