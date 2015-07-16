# == Schema Information
#
# Table name: slot_managers
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  start_date      :date
#  end_date        :date
#  is_recurring    :boolean          default(TRUE)
#  exclusions      :text
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe SlotManager, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
