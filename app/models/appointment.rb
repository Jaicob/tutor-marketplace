# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  start_time :datetime
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Appointment < ActiveRecord::Base
  belongs_to :student
  belongs_to :slot
  delegate :tutor, to: :slot

  validates :student_id, presence: true
  validates :slot_id, presence: true
  validates :start_time, presence: true, uniqueness: { scope: :slot_id }
  validate :one_hour_appointment_buffer
  validate :inside_slot_availability

  attr_accessor :appt_reminder_email_date

  def one_hour_appointment_buffer
    Slot.find(slot_id).appointments.each do |appt|
      start_time_diff = (appt.start_time - start_time).abs
      if start_time_diff < ( 3600 ) && start_time_diff != 0 
        errors.add(:start_time, "can't be within an hour of another appointment")
      end
    end
  end

  def inside_slot_availability
    slot = Slot.find(slot_id)
    slot_last_available_appt = slot.start_time + slot.duration - 3600
    if start_time < slot.start_time || start_time > slot_last_available_appt
      errors.add(:start_time, "is not inside slot's availability")
    end
  end

  # This sets the delivery time for reminder emails as 12 hours before the appointment, except in the case where the appointment is tomorrow and no reminder is needed
  def appt_reminder_email_date
    if self.start_time.to_date > (self.created_at.to_date + 1)
      (self.start_time.to_time - 43200).to_i 
    end
  end

end
