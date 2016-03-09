class TutorAvailability

  def initialize(tutor_id, start_date, week_change)
    @tutor_id = tutor_id
    @tutor = Tutor.find(tutor_id)
    @timezone = @tutor.school.timezone
    @start_date = if start_date then start_date.to_date else Date.today.in_time_zone(@timezone).to_date end
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
    @availability = possible_appt_times_for_week(@start_date, @tutor_id)
    return @availability
  end

  def possible_appt_times_for_week(start_date, tutor_id)
    availability = {}

    7.times do |x|
      appt_times = possible_appt_times_for_date(tutor_id, start_date)
      
      availability[x] = {
        date: start_date,
        times: appt_times,
        count: appt_times.count,
      }

      start_date += 1
    end

    return availability
  end

  def possible_appt_times_for_date(tutor_id, date)
    # reset appt_times array
    appt_times = nil
    appt_times = []
    
    # find any slots for given date and tutor

    slots_in_week = @tutor.slots.select{|slot| slot.start_time.in_time_zone(@timezone).to_date == date}

    Slot.where(tutor_id: tutor_id).each do |slot|
      if slot.start_time.in_time_zone(@timezone).to_date == date
        # get number of start_times to put in array - (subtract one bc last 30 minutes of availability isn't a possible start time)
        x = ((slot.duration / 1800) - 1 )
        # find unavailable times due to existing appointments
        unavailable_times = slot.appointments.select{|appt| appt.status != 'Cancelled'}.map{|appt| appt.start_time}
        # set slot's first start_time (then incremented by '1800' or 30 min. at end of each loop)
        start_time = slot.start_time
        # used to create unique IDs for all time pills for correct targeting with selection, de-selection via JS
        uniq_id = 0
        x.times do
          data = {
            time: start_time.strftime('%l:%M %p'),
            datetime: start_time,
            uniq_id: slot.id.to_s + sprintf('%02i', uniq_id).to_s, # have to add slot_id to make unique + sprintf adds zero-padding to numbers under 10 which allows the disabledNeigboringCheckboxes to function (otherwise the number jumps a whole tens place from id 9 to id 10)
            slot_id: slot.id
          }
          # mark time pills requiring disabling by JS
          if unavailable_times.include?(start_time) || slot.status == 'Blocked'
            data[:reserved] = 'reserved' # used to set CSS class which is disabled by JS
          end
          # add data hash to appt_times array
          appt_times << data
          # increment uniq_id and start_time
          uniq_id += 1
          start_time += 1800 # adds a 1/2 hour to the start_time each iteration
        end
        
        # if date is today's date, pass to extra method to add 'unavailable' class to start times that have been passed and/or are inside a tutor's booked_buffer unavailability
        if date == Date.today
          mark_unavailable_times(appt_times)
        end
      end
    end

    ordered_appt_times = appt_times.sort_by{|data| data[:datetime]}
    return ordered_appt_times
  end

  def mark_unavailable_times(appt_times)
    buffer = Tutor.find(@tutor_id).booking_buffer * 3600 
    earliest_avail_appt_time = Time.now + buffer

    appt_times.each do |data|
      if data[:datetime].to_datetime < earliest_avail_appt_time
        data[:reserved] = 'reserved'
      end
    end
  end

  def reserved_times_for_existing_appts(tutor_id, date)
    # necessary to reset to nil since this is called in succession and times will carry over in array
    existing_appt_times = nil
    existing_appt_times = []
    # find any slots for given date and tutor
    Slot.where(tutor_id: tutor_id).each do |slot|
      if slot.start_time.to_date == date
        slot.appointments.each do |appt|
          existing_appt_times << appt.start_time
        end
      end
    end
    return existing_appt_times
  end

end