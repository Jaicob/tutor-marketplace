require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do

# NOTE: the tests that check that emails are actually sent and sent to the right email addresses are in the API request specs. Tests to go here are unit-tests for emails that verify the correct information is in specific emails. This may or may not be necessary to test.

#   let(:student) { create(:student) }
#   let(:tutor) { create(:complete_tutor) }
#   let(:slot) { create(:slot, tutor_id: tutor.id)}
#   let(:appointment) { create(:appointment, student_id: student.id, slot_id: slot.id) } 

#   describe 'appointment confirmation email' do
#     let(:tutor_email) { AppointmentMailer.appointment_confirmation_for_tutor(appointment) }
#     let(:student_email) { AppointmentMailer.appointment_confirmation_for_student(appointment) }

#     it 'has the correct information in the confirmation email for a tutor' do 
#       expect(tutor_email.subject).to eq "You have a new appointment!"
#       expect(tutor_email.to).to eq [tutor.email]
#       expect(tutor_email.from).to eq ["info@axontutors.com"]
#     end

#    it 'sends the student an email when an appointment is booked' do
#    end

#    it 'has the correct information in the confirmation email for a stident' do 
#       expect(student_email.subject).to eq "Your Axon tutoring appointment confirmation"
#       expect(student_email.to).to eq [student.email]
#       expect(student_email.from).to eq ["info@axontutors.com"]
#     end
#   end

#   describe 'appointment update email' do 
#     let(:tutor_email) { AppointmentMailer.appointment_update_for_tutor(appointment) }
#     let(:student_email) { AppointmentMailer.appointment_update_for_student(appointment) }
#   end

#   describe 'appointment reminder email' do 
#   end
# end

end
