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

  # Use this to test it out in rails console
  #s = TutorSearch.new(school: "UGA", course: "1212", dow: "Mon")
  def initialize(params)
    @search_config = 0
    @search_config |= ( 1 << SCHOOL ) if(params.has_key?(:school))
    @search_config |= ( 1 << COURSE ) if(params.has_key?(:course))
    @search_config |= ( 1 << DOW )    if(params.has_key?(:dow))
  end

  def search
    results = []

    case @search_config
    when Search_By::SCHOOL
      results = tutors_for_school
    when Search_By::COURSE
      results = tutors_for_course
    when Search_By::DOW
      results = tutors_for_dow
    when Search_By::SCHOOL_COURSE
      results = tutors_for_school_course
    when Search_By::SCHOOL_COURSE_DOW
      results = tutors_for_school_course_dow
    else
      # Handle invalid search params here
    end

    return results
  end

  private

    def tutors_for_school
      Tutor.joins(:schools).where(schools: { name: "University of Georgia" })
    end

    def tutors_for_course
      Tutor.joins(:tutor_courses).where(tutor_courses: { course_id: params[:course].id })
    end

    def tutors_for_dow

    end

    def tutors_for_school_course

    end

    def tutors_for_school_course_dow

    end

end

