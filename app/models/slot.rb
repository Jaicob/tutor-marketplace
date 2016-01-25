# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  duration        :integer
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slot_type       :integer          default(0)
#

class Slot < ActiveRecord::Base
  belongs_to :tutor
  has_many :appointments, dependent: :destroy

  validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true
  validates :status, presence: true

  before_validation :format_datetime

  enum status: ['Open', 'Blocked']
  enum slot_type: ['Weekly', 'OneTime']

  # Ensure that datetimes are always saved as UTC 
  def format_datetime
    self.start_time = self.start_time.in_time_zone("UTC")
  end

end

# slot.tutor.school.timezone

#     self.start_time.in_time_zone(self.school.timezone).strftime('%A -  %-m/%d/%y - %l:%M %p')
#   end

#   def time
#     self.start_time.in_time_zone(self.school.timezone).strftime('%l:%M %p')


# 7138
# Wednesday -  2/03/16 -  9:00 AM
# 14400
# =======

# 2857
# Wednesday -  2/03/16 -  3:00 PM
# 10800
