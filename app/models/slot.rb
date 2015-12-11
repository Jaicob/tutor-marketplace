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
#

class Slot < ActiveRecord::Base
  belongs_to :tutor
  has_many :appointments, dependent: :destroy

  validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true
  validates :status, presence: true

  enum status: ['Open', 'Blocked']

  def self.possible_appt_times(tutor_id, date)
    @start_times_array = nil # necessary to reset to nil since this is called in succession and times will carry over
    Slot.where(tutor_id: tutor_id).each do |slot|
      if slot.start_time.to_date == date
        x = (slot.duration / 1800) - 1 # equals number of possible start times for an appointment
        @start_times_array = []
        start_time = slot.start_time
        x.times do
          @start_times_array << start_time
          start_time += 1800 # adds a 1/2 hour to the start_time each iteration
        end
        @start_times_array = @start_times_array.map{|time| time.strftime('%l:%M %p')}
      end
    end
    @start_times_array
  end

end

# Slot.appt_times(Tutor.first, Date.today - 1)