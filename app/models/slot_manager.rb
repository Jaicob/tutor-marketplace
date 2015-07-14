class SlotManager < ActiveRecord::Base
  belongs_to :tutor
  has_many :slots
end
