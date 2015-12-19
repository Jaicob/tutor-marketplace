class TutorAvailability

  def initialize(tutor_id, start_date, week_change)
    @tutor_id = tutor_id
    @start_date = if start_date then start_date.to_date else Date.today end
    @week_change = week_change
  end

  def set_week
    if @week_change == '0'
      @start_date -= 7
    elsif @week_change == '1'
      @start_date += 7
    end
    return @start_date
  end

  def get_times
    @availability_data = possible_appt_times_for_week(@start_date, @tutor_id)
    return @availability_data
  end

  def possible_appt_times_for_week(start_date, tutor_id)
    availability_data = {}
    7.times do |count|
      availability_data[count] = {
        date: start_date,
        times: possible_appt_times_for_date(tutor_id, start_date)
      }
      start_date += 1
    end
    availability_data
  end

  def possible_appt_times_for_date(tutor_id, date)
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
            available: unavailable_times.include?(start_time) ? false : true
          }
          appt_times << data
          start_time += 1800 # adds a 1/2 hour to the start_time each iteration
        end
      end
    end
    appt_times
  end

end