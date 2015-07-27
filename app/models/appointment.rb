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

  validate :one_hour_appointment_buffer
  validates :student_id, presence: true
  validates :slot_id, presence: true
  validates :start_time, presence: true, uniqueness: { scope: :slot_id }

  # def one_hour_appointment_buffer
  #   Slot.find(slot_id).appointments.each do |appt|
  #     diff = (appt.start_time - start_time)
  #     puts "#{appt.start_time} - #{start_time} =  #{diff}"
  #     puts "#{diff.class}"
  #       errors.add(:start_time, "can't be within an hour of another appointment")
  #   end
  # end

  # 2015-08-01 12:00:00+00:00 - 2015-08-01 12:00:00+00:00 =  0.0
  # 2015-08-01 01:00:00+00:00 - 2015-08-01 12:00:00+00:00 =  -39600.0

  def one_hour_appointment_buffer
    puts "SLOT ID = #{slot_id}"
    puts "SLOT APPT COUNT = #{Slot.find(slot_id).appointments.count}"
    # Slot.find(slot_id).appointments.each do |appt|
    #   if (appt.start_time - start_time) < ( 3600 || -3600 )
    #     errors.add(:start_time, "can't be within an hour of another appointment")
    #   end
    # end
  end


end

# # @appt = Appointment.create(student_id: 1, slot_id: 1, start_time: '2015-8-01 12:00:00', status: nil)

# # Validations

# # CHECK - a slot can only have one appointment at a specific start_time

# # TO DO - after an appointment is made, a slot cannot have anymore appointments until a full hour after the previous appointment



# a => Sat, 01 Aug 2015 12:00:00 +0000
# b => Sat, 01 Aug 2015 13:00:00 +0000
# a - b => (-1/24)

# a => Sat, 01 Aug 2015 12:00:00 +0000
# c => Sat, 01 Aug 2015 12:30:00 +0000
# a-c => (-1/48)

# a => Sat, 01 Aug 2015 12:00:00 +0000
# d => Sun, 09 Aug 2015 12:00:00 +0000
# a - d => (-8/1)
