module CheckoutHelper

  def get_week_dates(start_date)
    @day_1 = start_date
    @day_1_slots = Slot.possible_appt_times(@tutor.id, @day_1)
    
    @day_2 = start_date + 1
    @day_2_slots = Slot.possible_appt_times(@tutor.id, @day_2)
    
    @day_3 = start_date + 2
    @day_3_slots = Slot.possible_appt_times(@tutor.id, @day_3)

    @day_4 = start_date + 3
    @day_4_slots = Slot.possible_appt_times(@tutor.id, @day_4)

    @day_5 = start_date + 4
    @day_5_slots = Slot.possible_appt_times(@tutor.id, @day_5)

    @day_6 = start_date + 5
    @day_6_slots = Slot.possible_appt_times(@tutor.id, @day_6)

    @day_7 = start_date + 6
    @day_7_slots = Slot.possible_appt_times(@tutor.id, @day_7)
  end

end

# Slot.possible_appt_times(6, Date.today + 3)