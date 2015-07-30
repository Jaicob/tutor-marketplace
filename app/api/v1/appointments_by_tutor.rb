module V1
  class AppointmentsByTutor < Grape::API

    include V1::Defaults

      helpers do
       
        def appt
          Appointment.find(params[:id])
        end

        def tutor
          Tutor.find(params[:tutor_id])
        end
      end

      params do 
        optional  :id,            type: Integer 
        optional  :student_id,    type: Integer
        optional  :slot_id,       type: Integer  
        optional  :start_time,    type: String
        optional  :status,        type: Integer
      end
      

    resource :tutors do
      segment "/:tutor_id" do
        resource :appointments do 

          desc "Returns list of all appointments for a tutor"
          get do
            tutor.appointments
          end

          desc "Returns a specific appointment for a tutor"
          get ":id" do 
            appt
          end

          desc "Updates an appointment for a tutor"
          put ":id" do
            @appt = appt
            if @appt.update(declared_params)
              AppointmentMailer.appointment_update_for_tutor(@appt).deliver_now
              AppointmentMailer.appointment_update_for_student(@appt).deliver_now 
              return @appt
            else
              return "Appointment was not updated: #{@appt.errors.full_messages}"
            end
          end        

        end
      end
    end

  end
end