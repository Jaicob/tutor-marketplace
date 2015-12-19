# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  duration        :integer
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Slot < ActiveRecord::Base
  belongs_to :tutor
  has_many :appointments, dependent: :destroy

  validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true
  validates :status, presence: true

  enum status: ['Open', 'Blocked']

end