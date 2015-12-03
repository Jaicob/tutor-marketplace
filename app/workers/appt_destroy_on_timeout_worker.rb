class ApptDestroyOnTimeoutWorker
  include Sidekiq::Worker 

  # This worker deletes an appointment after 10 minutes if charge_id is blank
  #  - Appointments are created when selected in the very beginning of the checkout process (before a charge exists)
  #    to avoid problems with two users trying to book the same time. In case a user leaves without
  #    completing the checkout process, appointments without a charge_id are deleted 10 minutes after creation to ensure
  #    that open times are visible to other students

  def perform(appt_id)
    @appt = Appointment.find(appt_id)
    if @appt.charge_id == nil
      @appt.destroy
    end
  end
end