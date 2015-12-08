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


  Promotion.create(category: 0, amount: nil, valid_from: Date.today, valid_until: Date.today + 10, redemption_limit: 1)


  CheckoutOrganizer.call(
    tutor_id: 1,
    student_id: 1,
    stripe_token: nil,
    appts_info: [
      {slot_id: 1, course_id: 1, start_time: "2015-12-08 12:00:00" },
      {slot_id: 2, course_id: 1, start_time: "2015-12-15 12:00:00" },
    ],
    promotion_id: 1
  )

