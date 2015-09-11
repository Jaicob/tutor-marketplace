# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:appointment) { build(:appointment) }
  let(:slot) { create(:slot) }

  it 'is valid with a student_id, slot_id and start_time' do
    expect(appointment).to be_valid
  end

  it 'is invalid with a start_time less than an hour before another appointment' do 
    expect(create(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:00')).to be_valid

    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 11:00')).to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 11:01')).not_to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 11:30')).not_to be_valid
  end

  it 'is invalid with a start_time less than an hour after another appointment' do 
    expect(create(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:00')).to be_valid

    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:01')).not_to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:30')).not_to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:59:59')).not_to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 13:00')).to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 13:01')).to be_valid
  end

  it "is invalid if an appointment doesn't fit inside a slot's time range" do 
    expect(create(:appointment, slot_id: slot.id, start_time: '2015-09-01 12:00')).to be_valid

    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 10:00')).to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 15:00')).to be_valid

    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 9:00')).not_to be_valid
    expect(build(:appointment, slot_id: slot.id, start_time: '2015-09-01 16:00')).not_to be_valid
  end

  it 'sets appt_reminder_email_date to nil for an appt booked less than 24 hours in advance' do 
    slot = create(:slot, start_time: DateTime.now)
    appt = create(:appointment, slot: slot, start_time: slot.start_time)
    expect(appt.appt_reminder_email_date).to be_nil
  end

  it 'sets appt_reminder_email_date for an appt booked more than 24 hours in advance' do
    appt_date_time = DateTime.now + 3
    reminder_email_time = (appt_date_time - 0.5).to_time # reminder emails are sent 12 hours prior to appt
    slot = create(:slot, start_time: appt_date_time)
    appt = create(:appointment, slot: slot, start_time: appt_date_time)
    expect(appt.appt_reminder_email_date).to eq(reminder_email_time)
    expect(reminder_email_time).to be_a Time
  end

end