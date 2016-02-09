class TutorAnalyzer

  def initialize(tutor)
    @tutor = tutor
  end

  def students
    @tutor.appointments.map{|appt| appt.student}.uniq{|student| student.id}
  end

  def availability_next_7_days
    slots = @tutor.slots.select{|slot| slot.start_time.to_time >= Time.now && slot.start_time.to_time <= Time.now + 7.days}
    hours = slots.map(&:duration).reduce(:+).to_f / 3600
    return hours
  end

  def appts_next_7_days
    @tutor.appointments.select{|appt| appt.start_time.to_time >= Time.now && appt.start_time.to_time <= Time.now + 7.days}
  end

  def total_appts
    appt_list = []
    @tutor.appointments.each do |appt|
      if appt.status == 'Scheduled' || appt.status == 'Completed'
        appt_list << appt
      end
    end
    return appt_list
  end

  def total_income
    if @tutor.appointments.count > 0
      charge_list = total_appts.map{|appt| appt.charge}
      total = charge_list.map(&:tutor_fee).reduce(:+)
    else
      total = 0
    end
    return total
  end

end