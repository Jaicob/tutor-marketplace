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


# When a tutor creates a slot, they have to choose whether it's repeating or whether it's a one-off.
# But, we are assuming that everything defaults to repeating and extends to the end of the semester right now.
# So we can assume all slot_managers will have:
#     is_reccuring = true 
#     end_date = December 16, 2015
# So the only things to be set are:
#     start_date = Day that is selected on Full Calendar that will be sent back as start_date
#

# -remove references to slot_manager
