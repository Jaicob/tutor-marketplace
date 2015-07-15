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
<<<<<<< HEAD
  has_many :slots, dependent: :destroy
  
  validates :tutor_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def slots_with_manager_info
  end

=======
  has_many :slots,  dependent: :destroy
>>>>>>> adjust-slot-duration
end


