# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :integer
#  location   :string
#

class Appointment < ActiveRecord::Base
  belongs_to :student
  belongs_to :slot
  belongs_to :course
  belongs_to :charge
  has_one :review, dependent: :destroy
  delegate :tutor, to: :slot
  delegate :school, to: :course

  validates :slot_id, presence: true
  validates :course_id, presence: true
  validate :start_time_uniqueness # needed custom validation here b/c built in validations cannot handle allowing a non-unique appt start_time/slot_id as long as any duplicates have a status of 'cancelled'
  validate :one_hour_appointment_buffer
  validate :inside_slot_availability
  validate :tutor_and_student_at_same_school
  validate :outside_booking_buffer

  before_validation :format_datetime
  after_find :update_status_for_complete_appts

  enum status: ['Scheduled', 'Cancelled', 'Completed']

  attr_accessor :appt_reminder_email_time, :appt_follow_up_email_time

  # custom validation
  def start_time_uniqueness
    Slot.find(slot_id).appointments.each do |appt|
      if appt.start_time == start_time && appt != self
        if appt.status != 'Cancelled'
          errors.add(:start_time, "is already booked")
        end
      end
    end
  end

  # custom validation
  def one_hour_appointment_buffer
    Slot.find(slot_id).appointments.each do |appt|
      if appt.status != 'Cancelled'
        start_time_diff = (appt.start_time - start_time).abs
        if start_time_diff < ( 3600 ) && start_time_diff != 0
          errors.add(:start_time, "can't be within an hour of another appointment")
        end
      end
    end
  end

  # custom validation
  def inside_slot_availability
    slot = Slot.find(slot_id)
    slot_last_available_appt = slot.start_time + slot.duration - 3600
    if start_time < slot.start_time || start_time > slot_last_available_appt
      errors.add(:start_time, "is not inside slot's availability")
    end
  end

  # custom validation
  def tutor_and_student_at_same_school
    if student_id != nil # allows for appt creation before student is logged in, but runs when student exists
      tutor_id = Slot.find(slot_id).tutor.id
      tutor = Tutor.find(tutor_id)
      student = Student.find(student_id)
      course = Course.find(course_id)
      if !(tutor.school.name == course.school.name && student.school.name == course.school.name)
        errors.add(:school_id, "is not the same for tutor, student and course: \ntutor and course = #{student.school.name == course.school.name}\nstudent and course = #{tutor.school.name == course.school.name}")
      end
    end
  end

  # custom validation
  def outside_booking_buffer
    buffer = (self.tutor.booking_buffer * 3600) # hours * 3600 = seconds
    earliest_avail_booking = Time.now + buffer
    if start_time < earliest_avail_booking
      errors.add(:start_time, "is too soon and does not meet minimum notice requirement for tutor")
    end
  end

  def update_status_for_complete_appts
    if (self.start_time + 1.hour) < DateTime.now && self.status == 'Scheduled'
      self.update_attribute('status', 2)
    end
  end

  # This sets the delivery time for reminder emails as 12 hours before the appointment, except in the case where the appointment is tomorrow and no reminder is needed
  def appt_reminder_email_time
    if self.start_time.to_date > (self.created_at.to_date + 1)
      self.start_time - 12.hours
    end
  end

  # This sets the delivery time for follow_up emails as 3 hours after the appointment
  def appt_follow_up_email_time
    self.start_time + 4.hours
  end

  # Ensure that datetimes are always saved as UTC
  def format_datetime
    self.start_time = self.start_time.in_time_zone("UTC")
  end

  # the next 3 helper methods format the start_time accordingly and apply the school's timezone
  def date
    # self.start_time.in_time_zone(self.school.timezone).strftime('%A -  %-m/%d/%y')
    "#{self.start_time.in_time_zone(self.school.timezone).strftime('%A')}</br>#{self.start_time.in_time_zone(self.school.timezone).strftime('%-m/%d/%y')}".html_safe()
  end

  def date_for_email
    # single line - so </br> tag doesn't show up in plain text email
    "#{self.start_time.in_time_zone(self.school.timezone).strftime('%A')} - #{self.start_time.in_time_zone(self.school.timezone).strftime('%-m/%d/%y')}"
  end

  def time
    self.start_time.in_time_zone(self.school.timezone).strftime('%l:%M %p')
  end

  # sends appropriate email based on changes made to an appt in Admin section
  def send_update_or_cancel_appt_email(appt_id, appt_params)
    if appt_params[:status] == 'Scheduled'
      AppointmentMailer.delay.appointment_update_for_tutor(appt_id)
      AppointmentMailer.delay.appointment_update_for_student(appt_id)
    end
    if appt_params[:status] == 'Cancelled'
      AppointmentMailer.delay.appointment_cancellation_for_tutor(appt_id)
      AppointmentMailer.delay.appointment_cancellation_for_student(appt_id)
    end
  end

  def tutor_rate
    self.tutor.tutor_courses.find_by(course_id: self.course_id).rate
  end

  def self.create_appts_from_array(params)
    params[:data].map do |data|
      data = data[1]
      Appointment.create(
        student_id: params[:student_id],
        slot_id: data[:slot_id],
        course_id: data[:course_id],
        start_time: data[:start_time]
      )
    end
  end

  def self.visitor_create_appts_from_array(params)
    params[:data].map do |data|
      data = data[1]
      Appointment.create(
        slot_id: data[:slot_id],
        course_id: data[:course_id],
        start_time: data[:start_time]
      )
    end
  end

  def no_reschedule_allowed?
    ((self.start_time.to_time - Time.now) / 24.hours) < 1 ? true : false
  end

end
