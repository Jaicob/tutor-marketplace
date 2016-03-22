class RegularApptScheduler

  # RegularApptScheduler.new(3, '2016-03-18 13:00:00 UTC----129')

  def initialize(tutor_id, appt_info)
    @appt_info = appt_info # format of: "2016-03-18 13:00:00 UTC----129"
    # calculated variables below
    @appt_datetime = DateTime.parse(@appt_info.split('----').first) # get first part of appt_info string from params[:checkbox_value] and convert to a DateTime object
    @appt_hour_24 = @appt_datetime.strftime('%H:%M') # gets hour and minute in a string
    @appt_dow = @appt_datetime.wday # gets day of week in integer (0-6), where 0 = Sunday
    @tutor = Tutor.find(tutor_id)
    @timezone = @tutor.school.timezone
  end

  def similar_appt_times
    # first get slots that include the same dow/time in other weeks
    slots = @tutor.slots.select do |slot|
      slot.start_time.to_date > DateTime.now.to_date && 
      slot.start_time.wday == @appt_datetime.wday && 
      slot.status == 'Open' &&
      # this last condition sets a DateTime range and then makes sure the appt_time is inside that range
      ((slot.start_time)..(slot.start_time + slot.duration.seconds)).cover?(DateTime.parse(slot.start_time.to_date.to_s + " " + @appt_hour_24))
    end
    # now create an array of slot_id, start_time and display time in hashes
    array = []
    slots.each do |slot|
      appt_start_time = DateTime.parse(slot.start_time.to_date.to_s + " " + @appt_hour_24).in_time_zone(@timezone)
      # end iteration and go to next slot in collection if a slot has an appointment that blocks the selected appt_time (includes exact appt time + 30 min. before and after)
      if blocked_by_scheduled_appts?(slot)
        next
      end
      # seems to repeat the condition in the first select block, but somehow some times were displaying slots from the same week while others weren't, maybe a timezone thing? either way, this extra validation here keeps the unwanted same day/identical appt out of the modal list 
      if appt_start_time != @appt_datetime
        array << {
          uniq_id: appt_start_time.strftime('%j-%H-%M'),
          slot_id: slot.id, 
          start_time: appt_start_time,
          time_display: format_time_and_date(slot)
        }
      end
    end
    return array
  end

  def original_time
    @appt_datetime.in_time_zone(@timezone).strftime('%A, %B %e at %l:%M %p')
  end

  private

    def format_time_and_date(slot)
      display_date = slot.start_time.in_time_zone(@timezone).strftime('%A, %B %e')
      display_hour = @appt_datetime.in_time_zone(@timezone).strftime('%l:%M %p')
      return display_date + ' at ' + display_hour
    end

    def blocked_by_scheduled_appts?(slot)
      # returns either true or false
      if slot.appointments.any?
        # run through all of a slots appointments to check start times
        slot.appointments.each do |appt|
          start_time = DateTime.parse(appt.start_time.to_s)
          # if start time of any appt in slot is the same, 30 mins before, or after the original start_time, the appt is not available that week
          if start_time.strftime('%H:%M') == @appt_datetime.strftime('%H:%M') ||
          (start_time).strftime('%H:%M') == (@appt_datetime + 30.minutes).strftime('%H:%M') ||
          (start_time).strftime('%H:%M') == (@appt_datetime - 30.minutes).strftime('%H:%M')
            return true
          else
            return false
          end
        end
      else
        return false
      end
    end

end