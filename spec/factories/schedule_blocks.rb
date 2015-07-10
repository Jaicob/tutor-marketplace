# == Schema Information
#
# Table name: schedule_blocks
#
#  id              :integer          not null, primary key
#  date            :date
#  start_time      :time
#  end_time        :time
#  status          :integer          default(0)
#  reservaton_min  :integer
#  reservation_max :integer
#  tutor_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :schedule_block do
    date Date.today
    start_time Time.now
    end_time Time.now
    status 0
    reservation_min nil
    reservation_max nil
    tutor
  end

end
