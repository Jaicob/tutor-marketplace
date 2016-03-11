class RegularApptScheduler

  def initialize(cart, params)
    @cart = cart
    @checkbox_value = params[:checkbox_value] # format of: "2016-03-18 13:00:00 UTC----129"
    # calculated variables below
    @appt_datetime = DateTime.parse(@checkbox_value.split('----').first) # get first part of appt_info string from params[:checkbox_value] and convert to a DateTime object
    @appt_hour = @appt_datetime.strftime('%H:%M') # gets hour and minute in a string
    @appt_dow = @appt_datetime.wday # gets day of week in integer (0-6), where 0 = Sunday
    @tutor = Tutor.find(@cart.info[:tutor_id])
  end

  def similar_appt_times
    # first get slots that include the same dow/time in other weeks
    @tutor.slots.select do |slot|
      slot.start_time.to_date > Date.today && 
      slot.start_time.wday == @appt_datetime.wday && 
      ((slot.start_time)..(slot.start_time + slot.duration.seconds)).cover?(DateTime.parse(slot.start_time.to_date.to_s + " " + @appt_hour))
    end
  end

  # private

  #   def extract_appt_time
  #     # stored in params[:checkbox_value] as "2016-03-18 13:00:00 UTC----129"
  #     # first part is appointment start_time
  #     # second part is slot_id (but don't need slot_id for this service)
  #     data = @checkbox_value.split('----')
  #     return data.first
  #   end

  # #  status          :integer          default(0)
  # #  start_time      :datetime
  # #  duration        :integer

  #   def get_slots_with_regular_time_inside
  #     @tutor.slots.select do |slot|
  #       slot.start_time.to_date > Date.today
  #       && slot.start_time.wday == @appt_time
  #     end
  #   end 


    # need to change this string "2016-03-18 13:00:00 UTC" to a DateTime.object


  # should take in appt_info from cart and find similar appointments
  # similar appointments are with the same tutor for the same day and time (every week it's available)
  # should output similar appointments and provide a way to schedule them with a checkbox, click, etc.
  # should add any selected similar appointments to hash in the same format that appts are added from regular time pills



# @cart.info: {
#   :appt_times=>{"12902"=>"2016-03-18 13:00:00 UTC----129", "12904"=>"2016-03-18 14:00:00 UTC----129", "12910"=>"2016-03-18 17:00:00 UTC----129"}
# }

end