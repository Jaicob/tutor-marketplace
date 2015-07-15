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
  has_many :slots, dependent: :destroy
  
  validates :tutor_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def create_slots
    @date = self.start_date
    regular_slot_dates = [@date]
    
    while @date < end_date
      regular_slot_dates << (@date + 7)
      @date = (@date + 7)
    end

    regular_slot_dates.each do |slot_date|
      self.slots.create(start_time: slot_date, end_time: slot_date)
    end
  end

  # We might want to make it so that this only affects slots that have NOT been individiually edited
  def update_all_slots(params)
    @params = params
    self.slots.each do |slot|
      slot.update_attributes(@params)
    end
  end
end


