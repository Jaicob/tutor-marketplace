# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  start_time :datetime
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :appointment do
    student
    slot 
    start_time '2015-09-01 12:00'
    
  end

end
