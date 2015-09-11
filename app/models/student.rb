# == Schema Information
#
# Table name: students
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Student < ActiveRecord::Base
  belongs_to :user
  has_many :appointments, dependent: :destroy

  delegate :school, :full_name, :email, :password, to: :user

  def subjects
    # returns subjects that a student makes appointments for, only used in Admin section for analytics
    subjects = []
    self.appointments.map{ |appt| 
      subjects << appt.course.subject[:name] unless subjects.include?(appt.course.subject[:name])
    }
  end

end
