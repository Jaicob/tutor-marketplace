module V1
  class AppointmentsByStudent < Grape::API

    include V1::Defaults

      helpers do 
        
        def appt
          Appointment.find(params[:id])
        end

        def student
          Student.find(params[:student_id])
        end
      end

      params do 
        optional  :id,            type: Integer 
        optional  :student_id,    type: Integer
        optional  :slot_id,       type: Integer  
        optional  :start_time,    type: String
        optional  :status,        type: Integer
      end
      

    resource :students do
      segment "/:student_id" do
        resource :appointments do 

          desc "Returns list of all appointments for a student"
          get do
            student.appointments
          end

          desc "Returns a specific appointment for a student"
          get ":id" do 
            appt
          end

          desc "Creates an appointment for a student"
          post do 
            @appt = student.appointments.create(declared_params)
            if @appt.save
              AppointmentMailer.delay.appointment_confirmation_for_tutor(@appt.id)
              AppointmentMailer.delay.appointment_confirmation_for_student(@appt.id)
              if @appt.appt_reminder_email_date != nil
                ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
                ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
              end
              return @appt
            else
              return "Appointment was not created: #{@appt.errors.full_messages}"
            end
          end

          # Disabled because we currently don't use this endpoint. Instead of one update endpoint, we currently have separate endpoints for two different update scenarios below:
          # 1) Rescheduling - changing start_time and possibly slot_id
          # 2) Cancelling - changing the appointment status to cancelled (NOT deleting the appointment)
          #
          # desc "Updates an appointment for a student"
          # put ":id" do 
          #   @appt = appt
          #   if @appt.update(declared_params)
          #     AppointmentMailer.delay.appointment_update_for_tutor(@appt.id)
          #     AppointmentMailer.delay.appointment_update_for_student(@appt.id)
          #     if @appt.appt_reminder_email_date != nil
          #       ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
          #       ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
          #     end
          #     return @appt
          #   else
          #     return "Appointment was not updated: #{@appt.errors.full_messages}"
          #   end
          # end

          desc "Reschedules an appointment for a student"
          put ":id/reschedule" do 
            @appt = appt
            if @appt.update(declared_params)
              AppointmentMailer.delay.appointment_update_for_tutor(@appt.id) 
              appointment_update_for_tutor(appointment_id)              
              AppointmentMailer.delay.appointment_update_for_student(@appt.id)
              return @appt
            else
              return "Appointment was not rescheduled: #{@appt.errors.full_messages}"
            end
          end

          desc "Cancels an appointment for a student"
          put ":id/cancel" do 
            @appt = appt
            if @appt.update(declared_params)
              AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
              AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
              return @appt
            else
              return "Appointment was not cancelled: #{@appt.errors.full_messages}"
            end
          end

          desc "Destroys an appointment for a student"
          delete ":id" do
            @appt = appt
            @appt_id = appt.id
            if @appt.destroy
              return "Appointment ##{@appt_id} succesfully destroyed."
            else
              return "Appointment was not destroyed: #{@appt.errors.full_messages}"
            end
          end
        
        end
      end
    end

  end
end