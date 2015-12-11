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
    @availability_data = Slot.possible_appt_times_for_week(@start_date, @tutor_id)
    return @availability_data
  end

end