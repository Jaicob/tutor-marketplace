class AdminDataCruncher

  def initialize(collection)
    @collection = collection # can be any AR collection (i.e. school.students, school.appointments, tutor.courses, etc.)
  end

  #===========================================================================================
  # Calculations on TUTORS
  #===========================================================================================

  def avg_tutor_rate_for_all_tutors # collection is AR collection of tutors
    return 0 if @collection.empty?
    tutors = @collection
    avg_rates = []
    tutors.each do |tutor|
      avg_for_one_tutor = (tutor.tutor_courses.map{|tc| tc.rate}.reduce(:+).to_f) / (tutor.tutor_courses.count)
      avg_rates << avg_for_one_tutor
    end
    average_of_averages = (avg_rates.reduce(:+).to_f) / (avg_rates.count)
    average_of_averages_in_cents = average_of_averages * 100
    return average_of_averages_in_cents
  end

  def avg_tutor_availability # collection is AR collection of tutors
    # tutors = @collection
    # tutors.each do |tutor|
    #   available_hours = []s
    #   tutor.slots.each do |slot|
    #     if (slot.start_time.to_time >= Time.now - 7.days) && (slot.start_time.to_time <= Time.now)
    #       available_hours = 
    #       slot.duration
    #     end
    #   end
    # end
  end

  def avg_tutor_appts_per_week # collection is AR collection of tutors
    # TODO-JT tutors = @collection
  end

  def avg_tutor_income_per_week # collection is AR collection of tutors
    # TODO-JT tutors = @collection
  end

  #===========================================================================================
  # Calculations on STUDENTS
  #===========================================================================================

  def active_students  # collection is AR collection of students
    return [] if @collection.empty?
    students = @collection
    active_students = []
    students.each do |student|
      if student.user.last_sign_in_at != nil
        if student.user.last_sign_in_at.to_time > (Time.now - 2.months)
          active_students << student
        end
      end
    end
    return active_students
  end

  def students_with_only_one_booking  # collection is AR collection of students
    return [] if @collection.empty?
    students = @collection
    student_list = []
    students.each do |student|
      student_list << student if student.appointments.count == 1
    end
    return student_list
  end

  def students_with_multiple_bookings  # collection is AR collection of students
    return [] if @collection.empty?
    students = @collection 
    student_list = []
    students.each do |student|
      student_list << student if student.appointments.count > 1
    end
    return student_list
  end
  
  def avg_num_of_bookings_per_student  # collection is AR collection of students
    return 0 if @collection.empty?
    students = @collection
    school = students.first.school
    avg = school.appointments.count.to_f / school.students.count
    return avg
  end
  
  def avg_num_of_appts_per_booking  # collection is AR collection of students
    return 0 if @collection.empty?
    students = @collection
    school = students.first.school
    unique_charge_ids = [] # essentially the same as unique bookings
    school.appointments.each do |appt|
      unique_charge_ids << appt.charge_id unless unique_charge_ids.include?(appt.charge_id)
    end
    avg = school.appointments.count.to_f / unique_charge_ids.count
    if !avg.nan? then return avg else return 0 end
  end


  #===========================================================================================
  # Calculations on APPOINTMENTS
  #===========================================================================================

  def appts_booked_this_week # collection is AR collection of appointments
    return [] if @collection.empty?
    appts = @collection
    appts_this_week = []
    appts.each do |appt|
      if appt.created_at.to_time >= Time.now - 1.week
        appts_this_week << appt
      end
    end
    return appts_this_week
  end

  def avg_appt_rate # collection is AR collection of appointments
    return 0 if @collection.empty?
    appts = @collection
    rates = appts.map{|appt| appt.charge.amount}
    total = rates.reduce(:+)
    avg = total.to_f / appts.count 
    return avg
  end

  def avg_appt_fee # collection is AR collection of appointments
    return 0 if @collection.empty?
    appts = @collection
    rates = appts.map{|appt| appt.charge.axon_fee}
    total = rates.reduce(:+)
    avg = total.to_f / appts.count 
    return avg
  end
  
  def avg_appts_per_week # collection is AR collection of appointments
    # TODO-JT appts = @collection
  end
  
  def todays_appts # collection is AR collection of appointments
    return [] if @collection.empty?
    appts = @collection
    appt_list = []
    appts.each do |appt|
      if appt.start_time.to_date == Date.today
        appt_list << appt
      end
    end
    return appt_list
  end
  
  def appts_booked_today # collection is AR collection of appointments
    return [] if @collection.empty?
    appts = @collection
    appt_list = []
    appts.each do |appt|
      if appt.created_at.to_date == Date.today
        appt_list << appt
      end
    end
    return appt_list
  end


  #===========================================================================================
  # Calculations on COURSES
  #===========================================================================================

  def top_5_courses  # collection is AR collection of courses
    return [] if @collection.empty?
    courses = @collection
    course_list = []
    courses.each do |course|
      course_list << [course, course.appointments.count] unless course.appointments.count == 0
    end
    course_list = course_list.sort_by{|course, count| count}
    return course_list
  end

  def booked_courses  # collection is AR collection of courses
    # TODO-JT courses = @collection
  end



end