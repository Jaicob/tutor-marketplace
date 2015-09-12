  # Use this to test it out in rails console
  #s = TutorSearch.new(has_availability: 1, school_id: 1, course_id: 1, dow: "Sat")

class TutorSearch
  attr_accessor :search_config

  # Search Config options
  SCHOOL = 0
  COURSE = 1
  DOW    = 2

  # Search bitmasks
  module Search_By
    SCHOOL            = 1
    COURSE            = 2
    DOW               = 4
    SCHOOL_COURSE     = 3
    SCHOOL_COURSE_DOW = 7
  end

  #
  # This looks at the existence of parameters and sets the associated bit if so
  #
  def initialize(params)
    @params = params
    @search_config = 0
    @search_config |= ( 1 << SCHOOL ) if(params.has_key?(:school_id))
    @search_config |= ( 1 << COURSE ) if(params.has_key?(:course_id))
    @search_config |= ( 1 << DOW )    if(params.has_key?(:dow))
    @requires_availability = true  if(params.has_key?(:has_availability))
    stringify_dow
  end

  #
  # Determines which search method to use based on which
  # bits where set in the initializer
  #
  def search
    results = []
    case @search_config
    when Search_By::SCHOOL
      results = tutors_for_school @params[:school_id]
    when Search_By::COURSE
      results = tutors_for_course @params[:course_id]
    when Search_By::DOW
      results = tutors_for_dow @string_dow
    when Search_By::SCHOOL_COURSE
      results = tutors_for_school_course @params[:school_id], @params[:course_id]
    when Search_By::SCHOOL_COURSE_DOW
      results = tutors_for_school_course_dow @params[:school_id], @params[:course_id], @string_dow
    end
    return results
  end

  private

  #
  # Calculate the string format of the dow, which is initially an integer
  #
  def stringify_dow
    @string_dow = ""
    case @params[:dow]
    when '0'
      @string_dow = "Sun"
    when '1'
      @string_dow = "Mon"
    when '2'
      @string_dow = "Tue"
    when '3'
      @string_dow = "Wed"
    when '4'
      @string_dow = "Thu"
    when '5'
      @string_dow = "Fri"
    when '6'
      @string_dow = "Sat"
    end
  end

  def tutors_for_school (school_id)
    school = School.find school_id
    if @requires_availability
      tutors = school.tutors.includes(:user, :slots).where.not(slots: { id: nil })
    else
      tutors = school.tutors.includes(:user)
    end
    return tutors.to_json(include: :user)
  end

  def tutors_for_course (course_id)
    course = Course.find course_id
    if @requires_availability
      tutors = course.tutors.includes(:user, :slots).where.not(slots: { id: nil })
    else
      tutors = course.tutors.includes(:user)
    end
    return tutors.to_json(include: :user)
  end

  #
  # Goes through each slot checking each tutors availability once and adds to them
  # to a set to maintain uniquness
  #
  def tutors_for_dow (desired_dow)
    tutors = Set.new []

    Slot.find_each do |slot|
      tutor = slot.tutor
      next if tutors.include? tutor
      current_dow = slot.start_time.strftime('%a')
      if @requires_availability
        tutors.add tutor if (current_dow == desired_dow && tutor.slots.any?)
      else
        tutors.add tutor if (current_dow == desired_dow)
      end
    end

    tutors.to_a()
  end

  def tutors_for_school_course (school_id, course_id)
    school = School.find school_id
    course = school.courses.find course_id
    tutors = course.tutors.includes(:user)
    return tutors.to_json(include: :user)
  end

  #
  # Returns the intersection of the tutors_for_school_course and tutors_for_dow results
  # could probably stand to be optimized in the future
  #
  def tutors_for_school_course_dow (school_id, course_id, dow)
    school_course_tutors = tutors_for_school_course(school_id, course_id)
    dow_tutors = tutors_for_dow(dow)
    school_course_tutors & dow_tutors
  end

end
