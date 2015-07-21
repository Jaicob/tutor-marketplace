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
#

require 'rails_helper'

RSpec.describe Slot, type: :model do

  it "is valid with a tutor_id, start_time and end_time" do
    expect(build(:slot)).to be_valid
  end

  it "is invalid without a tutor_id" do 
    expect(build(:slot, tutor_id: nil)).not_to be_valid
  end

  it "is invalid without a start_time" do 
    expect(build(:slot, start_time: nil)).not_to be_valid
  end

  it "is invalid without an end_time" do
    expect(build(:slot, end_time: nil)).not_to be_valid
  end

  it "is given a default status of 'Open'" do 
    expect(build(:slot).status).to eq('Open')
  end

  it "is capable of having a status of 'Blocked'" do 
    expect(build(:slot, status: 1).status).to eq('Blocked')
  end

end
