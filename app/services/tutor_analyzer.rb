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
    @tutor.appointments.select{|appt| appt.status == 'Scheduled' || appt.status == 'Completed'}
  end

  def completed_appts
    @tutor.appointments.select{|appt| appt.status == 'Completed'}
  end

  def total_income
    valid_appts = @tutor.appointments.select{|appt| appt.status != 'Cancelled'}
    if valid_appts.count > 0
      total = valid_appts.map{|appt| appt.charge.tutor_fee}.reduce(:+)
    else
      total = 0
    end
    return total
  end

  def approval
    @tutor.reviews.count > 0 ? (@tutor.reviews.select{|review| review.rating == 'Positive'}.count / @tutor.reviews.count.to_f * 100).round(0) : 0
  end

end
