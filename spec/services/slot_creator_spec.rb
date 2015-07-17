require 'rails_helper'


# describe Account do
#   context "when opened" do
#     it "logger#account_opened was called once" do
#       logger = double("logger")
#       account = Account.new
#       account.logger = logger

#       logger.should_receive(:account_opened).once

#       account.open
#     end
#   end
# end


RSpec.describe SlotCreator do

  let(:tutor) { create(:tutor) }

  describe ".create_slots" do
    it "Slot#create was called at least three times" do
      slot_creator = SlotCreator.new tutor_id: tutor.id, start_date: '2015-08-01', end_date: '2015-09-01', start_time: '2015-07-16T17:00:16+00:00', end_time: '2015-07-16T19:00:16+00:00' 
      expect{
        slot_creator.create_slots
        }.to change(Slot, :count).by(5)
    end
  end

end




