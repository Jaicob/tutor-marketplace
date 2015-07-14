# == Schema Information
#
# Table name: slot_managers
#
#  id           :integer          not null, primary key
#  tutor_id     :integer
#  start_date   :date
#  end_date     :date
#  is_recurring :boolean          default(TRUE)
#  exclusions   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SlotManager < ActiveRecord::Base
  belongs_to :tutor
  has_many :slots
end
