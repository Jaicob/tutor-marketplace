class CancelledApptRefunder

  def initialize(appt, cancelling_party)
    @cancelling_party = cancelling_party
    @tutor = appt.tutor
    @student = appt.student
    @appt = appt
    @charge = @appt.charge
    @stripe_charge_id = @charge.stripe_charge_id 
  end

  def issue_valid_refund
    if @cancelling_party.role == 'tutor'
      desc = "Refund for Cancelled Appointment | Cancelled by TUTOR at #{DateTime.now.strftime('%l:%M %p on %-m-%-d-%Y')} | Tutor: #{@tutor.full_name} | Student: #{@student.full_name} | Appointment ID: #{@appt.id}"
      Processor::Stripe.new.issue_refund(@stripe_charge_id, desc)
      refund_status = "Appointment was succesfully cancelled and a refund to the student was initiated. Please be sure to account for a withdrawal of $#{display_full_price(@charge.amount)} from your bank account if you have already received the funds."
    else
      # cancelled by Student, so appt must be more than 24 hrs away to recieve refund
      hours_before_appt = ((@appt.start_time.to_time - Time.now) / 1.hour)
      if hours_before_appt >= 24
        desc = "Refund for Cancelled Appointment | Cancelled by STUDENT at #{DateTime.now.strftime('%l:%M %p on %-m-%-d-%Y')} | Tutor: #{@tutor.full_name} | Student: #{@student.full_name} | Appointment ID: #{@appt.id}"
        Processor::Stripe.new.issue_refund(@stripe_charge_id, desc)
        refund_status = "Appointment was succesfully cancelled and your refund for $#{display_full_price(@charge.amount)} has been initiated. Please allow 48 hours for the refunded amount to appear in your account."
      else
        refund_status = "Appointment was succesfully cancelled. However, since you cancelled within 24 hours of the appointment, no refund has been issued. If you would like to reverse this cancellation please email your tutor and info@axontutors.com immediately."
      end
    end
    return refund_status
  end

  def display_full_price(amount_in_cents)
    amount_in_dollars = amount_in_cents / 100.to_f
    sprintf('%.2f', amount_in_dollars)
  end

end