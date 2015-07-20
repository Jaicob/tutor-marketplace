# == Schema Information
#
# Table name: slots
#
#  id              :integer          not null, primary key
#  tutor_id        :integer
#  status          :integer          default(0)
#  start_time      :datetime
#  end_time        :datetime
#  reservation_min :integer
#  reservation_max :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  start_dow_time  :string
#  end_dow_time    :string
#

class Slot < ActiveRecord::Base
  after_initialize :start_dow_time, :end_dow_time
  belongs_to :tutor

  validates :tutor_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum status: ['Open', 'Blocked']

  # def start_dow_time
  #   self.start_dow_time = self.start_time.strftime('%a %T')
  #   self.save
  # end

  # def end_dow_time
  #   self.end_dow_time = self.end_time.strftime('%a %T')
  #   self.save
  # end

end
