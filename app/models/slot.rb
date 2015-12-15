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

  def self.possible_appt_times_for_date(tutor_id, date)
    # necessary to reset to nil since this is called in succession and times will carry over in array
    appt_times = nil 
    # find any slots for given date and tutor
    Slot.where(tutor_id: tutor_id).each do |slot|
      if slot.start_time.to_date == date
        # get number of start_times to put in array - (subtract one bc last 30 minutes of availability isn't a possible start time)
        x = ((slot.duration / 1800) - 1 )
        # find unavailable times due to existing appointments
        unavailable_times = []
        slot.appointments.each do |appt|
          unavailable_times << appt.start_time
        end
        # create array for holding possible appt_times
        appt_times = []
        # set start_time for all possible appt_times (incremented by '1800' or 30 min. at end of times loop)
        start_time = slot.start_time
        x.times do
          data = {
            time: start_time.strftime('%l:%M %p'),
            datetime: start_time,
            slot_id: slot.id,
            date_and_slot_info: {
              start_time: start_time,
              slot_id: slot.id
            },
            available: unavailable_times.include?(start_time) ? false : true
          }
          appt_times << data
          start_time += 1800 # adds a 1/2 hour to the start_time each iteration
        end
      end
    end
    appt_times
  end

  # this gives me all the possible appt_start times for a date, but with no regard to spots that are taken
  # i need to find any booked appts on a slot and set available to false for those start times

  def self.possible_appt_times_for_week(start_date, tutor_id)
    availability_data = {}
    7.times do |count|
      availability_data[count] = {
        date: start_date,
        times: Slot.possible_appt_times_for_date(tutor_id, start_date)
      }
      start_date += 1
    end
    availability_data
  end

end

          # data = {
          #   time: start_time.strftime('%l:%M %p'),
          #   datetime: start_time,
          #   slot_id: slot.id,
          #   date_and_slot_info: "start_time: " + start_time.to_s + " slot_id: " + slot.id.to_s,
          #   available: unavailable_times.include?(start_time) ? false : true
          # }