# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  duration        :integer
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slot_type       :integer          default(0)
#

class Slot < ActiveRecord::Base
  belongs_to :tutor
  has_many :appointments

  validates :tutor_id, presence: true
  validates :start_time, presence: true, uniqueness: {scope: :tutor_id, message: 'start_time already taken for tutor'}
  validates :duration, presence: true
  validates :status, presence: true
  validate :no_slot_overlap

  before_validation :format_datetime

  enum status: ['Open', 'Blocked', 'Zombie']
  enum slot_type: ['Weekly', 'OneTime']

  # Ensure that datetimes are always saved as UTC
  def format_datetime
    self.start_time = self.start_time.in_time_zone("UTC")
  end
  
  # custom validation
  def no_slot_overlap
    @new_slot_range = start_time..(start_time + duration.seconds)
    same_day_slots = Tutor.find(tutor_id).slots.select{|slot| slot.start_time.to_date == start_time.to_date}
    same_day_slots.each do |slot|
      existing_slot_range = slot.start_time..(slot.start_time + slot.duration.seconds)
      if existing_slot_range.overlaps?(@new_slot_range)
        errors.add(:start_time, "start_time and duration result in overlap with an existing slot for tutor")
      end
    end
  end

end