require 'rails_helper'

RSpec.describe SlotManager do

  let(:tutor) { create (:tutor) }
  
  before :each do
    slot_creator = SlotCreator.new(
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      duration: 1200, 
      weeks_to_repeat: 5
    ) 
    slot_creator.create_slots
    
    @slot_manager = SlotManager.new(
      tutor_id: tutor.id, 
      original_start_time: '2015-08-01 12:00:00', 
      original_duration: 1200, 
      new_start_time: '2015-08-02 9:00:00', 
      new_duration: 2400
    )
    @slots = @slot_manager.get_slots_for_range
  end

  it "updates the start time of all slots in a slot_manager" do 
    expect(@slots.first.start_time).to eq('2015-08-01 12:00:00')
    expect(@slots.last.start_time).to eq('2015-08-29 12:00:00')  

    @slot_manager.update_slots

    expect(@slots.first.start_time).to eq('2015-08-02 9:00:00')
    expect(@slots.last.start_time).to eq('2015-08-30 9:00:00')
  end

  it "updates the duration of all slots in a slot_manager" do 
    expect(@slots.first.duration).to eq(1200)
    expect(@slots.last.duration).to eq(1200)

    @slot_manager.update_slots

    expect(@slots.first.duration).to eq(2400)
    expect(@slots.last.duration).to eq(2400)
  end
end