# == Schema Information
#
# Table name: students
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  school_id     :integer
#  phone_number  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :string
#  last_4_digits :string
#  card_brand    :string
#

class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_many :charges
  has_many :appointments
  has_many :reviews, through: :appointments
  has_many :students_promotions, class_name: StudentsPromotions
  has_many :promotions, through: :students_promotions

  validates :school_id, presence: true

  delegate :full_name, :first_name, :last_name, :public_name, :email, :password, to: :user

  def courses
    self.appointments.map{|appt| appt.course}.uniq{|course| course.id}.map{|course| course.friendly_name}
  end

  def last_appointment
    self.appointments.sort_by{|appt| appt.start_time}.first
  end

  def recent_appt?
    appts_in_last_week = self.appointments.select{|appt| 
      appt.start_time.to_date >= (Date.today - 7.days) &&
      appt.start_time.to_date <= (Date.today)
    }
    appts_in_last_week.any? ? 'Yes' : 'No'
  end

end
