class CheckoutOrganizer
  include Interactor::Organizer

  organize CreateAppointments, CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails

end

##
# Params for easy setup/testing in console

# @promotion = Promotion.create(category: 5, amount: 10, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 200, tutor_id: 23)

# params = {
#   tutor: Tutor object,
#   student: Student object,
#   appointments: [array of Appointment objects],
#   promotion_id: promotion_id,
# }

  # rates: [array of integers (representing dollar amounts)],
  # transaction_percentage: 15.0,

  #  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :integer
#

class Appointment < ActiveRecord::Base
  belongs_to :student
  belongs_to :slot
  belongs_to :course
  belongs_to :charge
  delegate :tutor, to: :slot
  delegate :school, to: :course

  validates :slot_id, presence: true
  validates :course_id, presence: true
  validates :start_time, presence: true, uniqueness: { scope: :slot_id }
  validate :one_hour_appointment_buffer
  validate :inside_slot_availability
  validate :tutor_and_student_at_same_school