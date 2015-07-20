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
  after_initialize :update_week_times # Set the week_times intially
  belongs_to :tutor

  validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum status: ['Open', 'Blocked']

 # Used to calculate the week_times TODO figure what callback to place this, its being called manually right now
  def update_week_times
    update_attribute(:start_week_time, start_time.strftime('%a %T'))
    update_attribute(:end_week_time, end_time.strftime('%a %T'))
  end

end
