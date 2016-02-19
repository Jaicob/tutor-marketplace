class ApptReviewCreator

  # if ApptReviewCreator.new(@student).reviews_needed?
  #   @reviews_needed = true
  #   @appts_to_review = ApptReviewCreator.new(@student).appts_to_review
  # end

  def initialize(student, params=nil)
    @student = student
    @params = params
  end

  # public method
  def reviews_needed?
    get_appts_to_review.any? ? true : false
  end

  # private method
  def get_appts_to_review
    unreviewed_appts = []
    @student.appointments.where(status: 2).each do |appt|
      if appt.review.nil?
        unreviewed_appts << appt
      end
    end
    return unreviewed_appts
  end

  # public method
  def format_appts_to_review
    appt_data = {}
    n = 0
    get_appts_to_review.each do |appt|
      appt_data[n] = {
        appt_id: appt.id,
        tutor_pic_url: appt.tutor.profile_pic_url(:thumb),
        tutor: appt.tutor.public_name,
        course: appt.course.formatted_name,
        time: appt.time,
        date: appt.date,
      }
      n += 1
    end
    return appt_data
  end

  # public method
  def create_reviews
    if @params[:appt_review]
      Review.create(
        appointment_id: @params[:appt_review][:appt_id],
        rating: @params[:appt_review][:rating],
        comment: @params[:appt_review][:comments],
      )
    end
  end
end
