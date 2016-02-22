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
    valid_appts = @tutor.appointments.select{|appt| appt.status != 'Cancelled'}
    if valid_appts.count > 0
      total = valid_appts.map{|appt| TutorCourse.find_by(course_id: appt.course.id, tutor_id: @tutor.id).rate}.reduce(:+) * 100
    else
      total = 0
    end
    return total
  end

  def approval
    return 93
    return @tutor.reviews.count > 0 ? @tutor.reviews.count/@tutors.reviews.where(rating: 0).count * 100 : 0
  end

  # def approval_rating
  #   if @tutor.reviews.count > 0
  #     total = @tutor.reviews.count;
  #     positive = @tutors.reviews.where(rating: 'Positive').count;
  #     return positive/total
  #   else
  #     return 0
  #   end
  # end

end
