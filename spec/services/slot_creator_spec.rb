require 'rails_helper'

RSpec.describe SlotCreator do
  let(:tutor) { create(:tutor) }
  let(:slot_creator_one_week) { SlotCreator.new(tutor_id: tutor.id, start_time: '2015-08-01 17:00', duration: 2, weeks_to_repeat: 1) }
  let(:slot_creator_five_weeks) { SlotCreator.new(tutor_id: tutor.id, start_time: '2015-08-01 17:00', duration: 3, weeks_to_repeat: 5) }

  it "creates correct amount of slots based on the weeks_to_repeat value" do
    expect{
      slot_creator_one_week.create_slots
      }.to change(Slot, :count).by(1)

    expect{
      slot_creator_five_weeks.create_slots
    }.to change(Slot, :count).by(5)
  end

end