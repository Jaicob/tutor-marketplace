# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Slot < ActiveRecord::Base
   before_validation :update_week_times

  belongs_to :tutor

  # validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  # def calc_weekday 
  # 	self.start_time.strftime('%a')
  # end

  # def calc_start_time
  # 	self.start_time.strftime('%T')
  # end

  # def calc_end_time
  # 	self.end_time.strftime('%T')
  # end

  def update_week_times
    update_attribute(:start_week_time, start_time.strftime('%a %T'))
    update_attribute(:end_week_time, end_time.strftime('%a %T'))
  end

  # def start_week_time
  # 	# update_attribute(:start_week_time, start_time.strftime('%a %T'))
  #   start_time.strftime('%a %T')
  # end

  # def end_week_time 
  #   # update_attribute(:end_week_time, end_time.strftime('%a %T'))
  #   end_time.strftime('%a %T')
  # end

  # scope :weekday, calc_weekday()
  # scope :s_time, calc_start_time()
  # scope :e_time, calc_end_time()

end




# tutor.slots.create(start_time: "2015-07-16 12:00", end_time: "2015-07-16 14:00")