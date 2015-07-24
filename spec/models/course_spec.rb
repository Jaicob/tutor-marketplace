# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject       :text
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

    # subject         {name: 'Biology', id: 1}
    # call_number     101
    # friendly_name   "Intro to Chemistry"
    # school

require 'rails_helper'

RSpec.describe Course, type: :model do

  it "is valid with a call_number, friendly_name, school_id and subject" do
    expect(build(:course)).to be_valid
  end

  it "is invalid without a call_number" do
    expect(build(:course, call_number: nil)).not_to be_valid
  end

  it "is invalid without a friendly_name" do 
    expect(build(:course, friendly_name: nil)).not_to be_valid  
  end

  it "is invalid without a school_id" do
    expect(build(:course, school_id: nil)).not_to be_valid
  end

  it "is invalid without a subject" do 
    expect(build(:course, subject: nil)).not_to be_valid
  end

  it "returns it's school name for .school_name" do
    expect(build(:course).school_name).to start_with('University')
  end

end


