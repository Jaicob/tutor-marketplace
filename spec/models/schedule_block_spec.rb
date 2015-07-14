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

require 'rails_helper'

RSpec.describe ScheduleBlock, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
