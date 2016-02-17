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
#  slot_type       :integer          default(0)
#

FactoryGirl.define do

  factory :slot do
    tutor
    status              0
    start_time          (Date.today + 2).to_s + " 12:00"
    duration            21600 # 6 hours
  end

end
