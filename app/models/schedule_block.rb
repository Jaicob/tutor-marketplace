# == Schema Information
#
# Table name: schedule_blocks
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  status          :integer          default(0)
#  reservation_min :integer
#  reservation_max :integer
#  tutor_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ScheduleBlock < ActiveRecord::Base
  belongs_to :tutor

  validates :date, presence: :true 
  validates :start_time, presence: :true 
  validates :end_time, presence: :true
  validates :tutor_id, presence: :true

  enum status: [:open, :blocked] 
end

