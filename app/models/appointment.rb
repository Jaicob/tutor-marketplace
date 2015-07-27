class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :slot  

  validates :user_id, presence: true
  validates :slot_id, presence: true
  validates :start_time, presence: true, uniqueness: {scope: :slot_id}

  def tutor
    self.slot.tutor
  end

end

# appt = Appointment.new(user_id: 21, slot_id: 1, start_time: '2015-08-01 12:00:00')