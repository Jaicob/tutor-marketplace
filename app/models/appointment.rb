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

  def one_hour_appointment_buffer
    Slot.find(slot_id).appointments.each do |appt|
      start_time_diff = (appt.start_time - start_time).abs
      if start_time_diff < ( 3600 ) && start_time_diff != 0 
        errors.add(:start_time, "can't be within an hour of another appointment")
      end
    end
  end
  # Above: the '!= 0' is necessary because the newly created slot is included in this loop and that math equals 0, but this doesn't let things slip through the cracks because the uniqueness validation on start_time ensures only one appointment in a given slot can have a specific start_time

  def inside_slot_availability
    slot = Slot.find(slot_id)
    slot_end_appt = slot.start_time + slot.duration - 3600
    if start_time < slot.start_time || start_time > slot_end_appt
      errors.add(:start_time, "is not inside slot's availability")
    end
  end

end


# @appt = Appointment.create(student_id: 1, slot_id: 1, start_time: '2015-08-01 13:00')