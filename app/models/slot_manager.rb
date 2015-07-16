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

class SlotManager < ActiveRecord::Base
  belongs_to :tutor
  has_many :slots, dependent: :destroy
  
  validates :tutor_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true


  def dates_for_regular_slots
    date = self.start_date
    slot_dates = [date]
    while date < end_date
      slot_dates << (date + 7) && date = (date + 7)
    end
    slot_dates
  end

  def create_regular_slots
    slot_dates = self.dates_for_regular_slots
    slot_dates.each do |slot_date|
      self.slots.create(start_time: self.start_time, end_time: self.end_time)
    end
  end

  def regular_slots_for_mass_update(params)
    attributes = []
    params.each do |k,v|
      attributes << k.to_s
    end
    regular_slots = []
    attributes.each do |attribute|
      self.slots.each do |slot|
        slot_attributes = slot.attributes
        slot_manager_attributes = self.attributes
        regular_slots << slot if slot_attributes[attribute] == slot_manager_attributes[attribute]
      end
    end
    regular_slots
  end

  # We want to make it so that this only affects slots that have NOT been individiually edited
  def update_regular_slots(params)
    regular_slots = self.regular_slots_for_mass_update(params)
    regular_slots.each do |slot|
      slot.update_attributes(params)
    end
  end
end


