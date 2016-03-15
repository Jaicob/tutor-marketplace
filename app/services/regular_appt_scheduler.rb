class RegularApptScheduler

  # RegularApptScheduler.new(3, '2016-03-18 13:00:00 UTC----129')

  def initialize(tutor_id, appt_info)
    @appt_info = appt_info # format of: "2016-03-18 13:00:00 UTC----129"
    # calculated variables below
    @appt_datetime = DateTime.parse(@appt_info.split('----').first) # get first part of appt_info string from params[:checkbox_value] and convert to a DateTime object
    @appt_hour_24 = @appt_datetime.strftime('%H:%M') # gets hour and minute in a string
    @appt_dow = @appt_datetime.wday # gets day of week in integer (0-6), where 0 = Sunday
    @tutor = Tutor.find(tutor_id)
  end

  def similar_appt_times
    # first get slots that include the same dow/time in other weeks
    slots = @tutor.slots.select do |slot|
      slot.start_time.to_date > DateTime.now.to_date && 
      slot.start_time.wday == @appt_datetime.wday && 
      # this last condition sets a DateTime range and then makes sure the appt_time is inside that range
      ((slot.start_time)..(slot.start_time + slot.duration.seconds)).cover?(DateTime.parse(slot.start_time.to_date.to_s + " " + @appt_hour_24))
    end
    # now create an array of slot_id, start_time and display time in hashes
    array = []
    slots.each do |slot|
      appt_start_time = slot.start_time.to_date.to_s + " " + @appt_hour_24
      if DateTime.parse(appt_start_time) != @appt_datetime
        array << {
          slot_id: slot.id, 
          start_time: appt_start_time,
          time_display: format_time_and_date(slot)
        }
      end
    end
    # remove the first appt/slot since it corresponds to the time just selected by user
    # array.shift
    return array
  end

  def original_time
    @appt_datetime.strftime('%A, %B %e at %l:%M %p')
  end

  private

    def format_time_and_date(slot)
      display_date = slot.start_time.strftime('%A, %B %e')
      display_hour = @appt_datetime.strftime('%l:%M %p')
      return display_date + ' at ' + display_hour
    end

end