# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Appointment < ActiveRecord::Base
  belongs_to :student
  belongs_to :slot
  belongs_to :course
  
  delegate :tutor, to: :slot
  delegate :school, to: :course

  validates :student_id, presence: true
  validates :slot_id, presence: true
  validates :course_id, presence: true
  validates :start_time, presence: true, uniqueness: { scope: :slot_id }
  validate :one_hour_appointment_buffer
  validate :inside_slot_availability
  validate :tutor_and_student_at_same_school

  enum status: ['Scheduled', 'Cancelled', 'Completed']

  attr_accessor :appt_reminder_email_date

  # custom validation
  def one_hour_appointment_buffer
    Slot.find(slot_id).appointments.each do |appt|
      start_time_diff = (appt.start_time - start_time).abs
      if start_time_diff < ( 3600 ) && start_time_diff != 0 
        errors.add(:start_time, "can't be within an hour of another appointment")
      end
    end
  end

  # custom validation
  def inside_slot_availability
    slot = Slot.find(slot_id)
    slot_last_available_appt = slot.start_time + slot.duration - 3600
    if start_time < slot.start_time || start_time > slot_last_available_appt
      errors.add(:start_time, "is not inside slot's availability")
    end
  end

  # custom validation
  def tutor_and_student_at_same_school
    tutor_id = Slot.find(slot_id).tutor.id
    tutor = Tutor.find(tutor_id)
    student = Student.find(student_id)
    course = Course.find(course_id)
    if !(tutor.school == course.school && student.school == course.school)
      errors.add(:course_id, "is not the same for tutor, student and course")
    end
  end

  # This sets the delivery time for reminder emails as 12 hours before the appointment, except in the case where the appointment is tomorrow and no reminder is needed
  def appt_reminder_email_date
    if self.start_time.to_date > (self.created_at.to_date + 1)
      (self.start_time.to_time - 43200).to_i 
    end
  end

  def formatted_start_time
    self.start_time.strftime('%-m-%d-%y %l:%M %p')
  end

  def date
    self.start_time.strftime('%-m-%d-%y')
  end

  def time
    self.start_time.strftime('%l:%M %p')
  end

  # sends appropriate email based on changes made to an appt in Admin section
  def send_update_or_cancel_appt_email(appt_id, appt_params)
    if appt_params[:status] == 'Scheduled'
      AppointmentMailer.delay.appointment_update_for_tutor(appt_id)               
      AppointmentMailer.delay.appointment_update_for_student(appt_id)
    end
    if appt_params[:status] == 'Cancelled'
      AppointmentMailer.delay.appointment_cancellation_for_tutor(appt_id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(appt_id)
    end
  end

end