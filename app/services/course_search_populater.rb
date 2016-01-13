class CourseSearchPopulater

  def initialize(school_id, subject_id=nil)
    @school = School.find(school_id)
    @subject = if subject_id then Subject.find(subject_id) end
  end

  def subjects_for_school
    subjects = subjects_with_tutors(@school)
  end

  def courses_with_active_tutors
    courses = @subject.courses.where(school_id: @school.id)
    return courses
  end


  def subjects_with_active_tutors
    subjects = []
    @school.tutors.where(active_status: 1).all.each do |tutor| # loop through 'Active' tutors
      tutor.courses.each do |course|
        if !subjects.include?(course.subject)
          subjects << course.subject
        end
      end
    end
    return subjects
  end

end