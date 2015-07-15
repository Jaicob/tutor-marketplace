# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  slot_manager_id :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Slot < ActiveRecord::Base
  belongs_to :slot_manager

  validates :slot_manager_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

end
