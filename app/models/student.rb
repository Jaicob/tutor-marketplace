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
  has_many :charges, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :students_promotions
  has_many :promotions, through: :students_promotions

  validates :school_id, presence: true

  delegate :full_name, :first_name, :last_name, :public_name, :email, :password, to: :user

  def subjects
    # returns subjects that a student makes appointments for, only used in Admin section for analytics
    subjects = []
    self.appointments.map{ |appt| 
      subjects << appt.course.subject[:name] unless subjects.include?(appt.course.subject[:name])
    }
  end

end
