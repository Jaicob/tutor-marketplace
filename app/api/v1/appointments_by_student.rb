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
              AppointmentMailer.appointment_confirmation(@appt).deliver_now
              return @appt
            else
              return "Appointment was not created: #{@appt.errors.full_messages}"
            end
          end

          desc "Updates an appointment for a student"
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