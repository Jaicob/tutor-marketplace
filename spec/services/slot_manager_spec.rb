require 'rails_helper'

RSpec.describe SlotManager do

  let(:tutor) { create (:tutor) }
  
  let(:slot_creator) {  SlotCreator.new(
      tutor_id: tutor.id, 
      start_time: '2015-08-01 12:00:00', 
      end_time: '2015-08-01 16:00:00', 
      weeks_to_repeat: 5) 
  }
  
  let(:slot_manager) { SlotManager.new(
    tutor_id: tutor.id, 
    original_start_time: '2015-08-01 12:00:00', 
    original_end_time: '2015-08-01 16:00:00', 
    new_start_time: '2015-08-02 9:00:00', 
    new_end_time: '2015-08-02 11:00:00') 
  }

  before :each do
    slot_creator.create_slots
    @slot_manager = slot_manager
    @slots = @slot_manager.get_slots_for_range
  end

  it "updates the start time of all slots in a slot_manager" do 
    expect(@slots.first.start_time).to eq('2015-08-01 12:00:00')
    expect(@slots.last.start_time).to eq('2015-08-29 12:00:00')  

    @slot_manager.update_slots

    expect(@slots.first.start_time).to eq('2015-08-02 9:00:00')
    expect(@slots.last.start_time).to eq('2015-08-30 9:00:00')
  end

  it "updates the end time of all slots in a slot_manager" do 
    expect(@slots.first.end_time).to eq('2015-08-01 16:00:00')
    expect(@slots.last.end_time).to eq('2015-08-29 16:00:00')

    @slot_manager.update_slots

    expect(@slots.first.end_time).to eq('2015-08-02 11:00:00')
    expect(@slots.last.end_time).to eq('2015-08-30 11:00:00')
  end

end


