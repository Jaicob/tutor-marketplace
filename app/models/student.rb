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

  delegate :school, :full_name, :email, to: :user

  def subjects
    subjects = []
    self.appointments.map{ |appt| 
      subjects << appt.course.subject[:name] unless subjects.include?(appt.course.subject[:name])
    }
  end

  # def days_since_last_appt
  #   x = self.appointments.first.start_time.to_date
  #   self.appointments.each do |appt|
  #     if x < appt.start_time.to_date
  #       x = appt.start_time.to_date
  #     end
  #   end
  #   abs(x - Date.today)
  # end

end
