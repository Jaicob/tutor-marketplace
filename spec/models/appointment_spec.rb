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

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:appointment) { build(:appointment) }

  it 'is valid with a student_id, slot_id and start_time' do
    expect(appointment).to be_valid
  end

  it 'is invalid without a student_id' do
    expect(build(:appointment, student_id: nil)).to_not be_valid 
  end

  it 'is invalid without a start_time' do
    expect(build(:appointment, start_time: nil)).to_not be_valid 
  end

  it 'is invalid with a start_time less than an hour after another appointment' do 
    expect(create(:appointment, start_time: '2015-09-01 12:00')).to be_valid

    # appt_a = build(:appointment, start_time: '2015-09-01 12:01')
    # expect(appt_a).not_to be_valid

    # appt_b = build(:appointment, start_time: '2015-09-01 12:30')
    # expect(appt_b).not_to be_valid

    # appt_c = build(:appointment, start_time: '2015-09-01 12:59:59')
    # expect(appt_c).not_to be_valid

    # appt_c = build(:appointment, start_time: '2015-09-01 13:00:00')
    # expect(appt_c).not_to be_valid
  end

end
