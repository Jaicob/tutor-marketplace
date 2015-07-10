# == Schema Information
#
# Table name: schedule_blocks
#
#  id              :integer          not null, primary key
#  date            :date
#  start_time      :time
#  end_time        :time
#  status          :integer
#  reservaton_min  :integer
#  reservation_max :integer
#  tutor_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :schedule_block do
    date "2015-07-10"
start_time "2015-07-10 13:43:07"
end_time "2015-07-10 13:43:07"
status 1
reservaton_min 1
reservation_max 1
tutor nil
  end

end
