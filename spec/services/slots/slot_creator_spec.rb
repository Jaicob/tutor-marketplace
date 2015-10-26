require 'rails_helper'

RSpec.describe SlotCreator do
  let(:tutor) { create(:tutor) }

  it "creates one slot with weeks_to_repeat set to 1" do
    slot_creator = SlotCreator.new(tutor_id: tutor.id, start_time: '2015-08-01 17:00', duration: 2, weeks_to_repeat: 1)
    expect{
      slot_creator.create_slots
      }.to change(Slot, :count).by(1)
  end

  it "creates five slots with weeks_to_repeat set to 5" do 
    slot_creator = SlotCreator.new(tutor_id: tutor.id, start_time: '2015-08-01 17:00', duration: 3, weeks_to_repeat: 5)
    expect{
      slot_creator.create_slots
    }.to change(Slot, :count).by(5)
  end
end