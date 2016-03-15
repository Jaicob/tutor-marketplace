require 'rails_helper'

RSpec.describe RegularApptScheduler do
  let(:tutor) { create(:tutor, :with_semester_availability) }
  let(:tutor_2) { create(:tutor, :with_2_weeks_availability) }
  let(:tutor_1) { create(:tutor, :with_1_week_availability) } # default tutor factory has no availability

  describe '.initialize' do 
    context 'with valid input (tutor_id and appt_info)' do 
      it 'creates a new instance' do 
        start_date = Date.today + 2.days
        appt_info = start_date.to_s + " 12:00" + '----' + tutor.slots.first.id.to_s
        expect(RegularApptScheduler.new(tutor.id, appt_info)).to be_a RegularApptScheduler
      end
    end
  end

  describe '#similar_appt_times' do

    context 'with tutor availability at time all semester' do 
      
      before :each do 
        appt_info = (Date.today + 2.days).to_s + " 12:00" + '----' + tutor.slots.first.id.to_s
        @service = RegularApptScheduler.new(tutor.id, appt_info)
      end

      it 'returns an array of hashes' do 
        expect(@service.similar_appt_times.first).to be_a Hash
      end

      it 'returns slot_id, start_time and time_display as keys in each hash' do 
        expect(@service.similar_appt_times.first.keys).to match_array [:slot_id, :start_time, :time_display]
      end

      it 'returns an array of 17 items' do
        expect(@service.similar_appt_times).to be_a Array
        expect(@service.similar_appt_times.count).to eq 17
      end
    end

    context 'with tutor availability for only 2 weeks' do

      it 'returns an array of 1 items' do 
        appt_info = (Date.today + 2.days).to_s + " 12:00" + '----' + tutor.slots.first.id.to_s
        service = RegularApptScheduler.new(tutor_2.id, appt_info)
        expect(service.similar_appt_times.count).to eq 1
      end
    end

    context 'with tutor availabilty for only the present week' do
      it 'returns an array of 0 items' do 
        appt_info = (Date.today + 2.days).to_s + " 12:00" + '----' + tutor.slots.first.id.to_s
        service = RegularApptScheduler.new(tutor_1.id, appt_info)
        expect(service.similar_appt_times.count).to eq 0
      end
    end
  end

  describe '#original_time' do
  end
end

  # def initialize(tutor_id, appt_info)
  #   @appt_info = appt_info # format of: "2016-03-18 13:00:00 UTC----129"
  #   # calculated variables below
  #   @appt_datetime = DateTime.parse(@appt_info.split('----').first) # get first part of appt_info string from params[:checkbox_value] and convert to a DateTime object
  #   @appt_hour_24 = @appt_datetime.strftime('%H:%M') # gets hour and minute in a string
  #   @appt_dow = @appt_datetime.wday # gets day of week in integer (0-6), where 0 = Sunday
  #   @tutor = Tutor.find(tutor_id)
  #   @timezone = @tutor.school.timezone
  # end

  # def similar_appt_times
  #   # first get slots that include the same dow/time in other weeks
  #   slots = @tutor.slots.select do |slot|
  #     slot.start_time.to_date > Date.today && 
  #     slot.start_time.wday == @appt_datetime.wday && 
  #     # this last condition sets a DateTime range and then makes sure the appt_time is inside that range
  #     ((slot.start_time)..(slot.start_time + slot.duration.seconds)).cover?(DateTime.parse(slot.start_time.to_date.to_s + " " + @appt_hour_24))
  #   end
  #   # now create an array of slot_id, start_time and display time in hashes
  #   array = []
  #   slots.each do |slot|
  #     array << {
  #       slot_id: slot.id, 
  #       start_time: slot.start_time.to_date.to_s + " " + @appt_hour_24,
  #       time_display: format_time_and_date(slot)
  #     }
  #   end
  #   # remove the first appt/slot since it corresponds to the time just selected by user
  #   # array = array.shift
  #   return array
  # end

  # def original_time
  #   @appt_datetime.strftime('%A, %B %e at %l:%M %p')
  # end