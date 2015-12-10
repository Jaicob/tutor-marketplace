class CheckoutController < ApplicationController

  def course_list # step 1
   # (view all courses a Tutor offers - bypassed from Search)
  end

  def available_times # step 2
   # (view all times that a Tutor is available - slots minus booked appointments)
  end

  def set_location # step 3
   # (view page with input for setting location)
  end

  def summary # step 4
   # (view checkout details - 'Your Booking' - plus field for Promo codes)
  end

  def login # step 5
   # (view two options - sign_up or sign_in - bypassed if already logged in)
  end

  def set_school_id_cookie
    session[:checkout_step] = 1
  end

end