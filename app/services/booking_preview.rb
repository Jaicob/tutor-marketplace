class BookingPreview

  def initialize(session, tutor)
    @appt_info = session[:appt_info]
    @location = session[:location]
    @course = Course.find(session[:course_id])
    @tutor = tutor
    @rate = TutorCourse.where(tutor_id: tutor.id, course_id: @course.id).first.rate
  end

  def extract_appt_times_and_slot
    @appt_hash = {}
    count = 1
    @appt_info.each do |info|
      array = info.second.split('-!-')
      @appt_hash[count] = {
        start_time: array.first,
        slot_id: array.second
      }
      count += 1
    end
    return @appt_hash
  end

  def format_info
    extract_appt_times_and_slot

    data = {
      tutor: @tutor,
      course: @course,
      rate: @rate,
      location: @location,
      appointments: @appt_hash
    }
    return data
  end

end

# info = {"11"=>"2015-12-16 12:00:00 UTC-!-164", "13"=>"2015-12-16 13:00:00 UTC-!-164"}