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
  has_many :appointments

  validates :tutor_id, presence: true
  validates :start_time, presence: true, uniqueness: {scope: :tutor_id, message: 'start_time already taken for tutor'}
  validates :duration, presence: true
  validates :status, presence: true
  
  before_validation :format_datetime

  enum status: ['Open', 'Blocked', 'Zombie']
  enum slot_type: ['Weekly', 'OneTime']

  # Ensure that datetimes are always saved as UTC
  def format_datetime
    self.start_time = self.start_time.in_time_zone("UTC")
  end

end