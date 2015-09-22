class ApplyPromoCode
  include Interactor


  def call
    promotion = Promotion.find(context.promotion_id).category
    promo_type = promotion.category
    puts "Promo type= #{promo_type}"
    case promo_type
    when 'Semester Package'
      puts "1"
      ApplyBundledPackagePromo.call
    when 'Dollar Amount Off'
      puts "2"
      ApplyDollarsOffPromo.call
    when  'Free'
      puts "3"
      ApplyFreeSessionPromo.call
    when 'Percent Off'
      puts "4"
      ApplyPercentageOffPromo.call
    end


 

    # puts "Promotion code = #{context.promotion_id}"

    # get type of coupon code
    # when its a free_session
    #   set amount to 0
    # when package_deal_coupon
    #   check if coupon is valid for chosen appts.
    #     are there enough credits?
    #     are the appts. eligible? (correct tutor)
    # when its a percentage_off_amount
    #   subtract x percent off of one appointment (first? most expensive? least expensive?)
    # when its a dollar_off_amount
    #   subtract x dollars from total price
    # end
  end


  
  #   transaction_percentage = ((context.transaction_percentage / 100) + 1)
  #   total_amount = []
  #   context.rates.each do |rate|
  #     session_amount = (rate * 100)
  #     total_amount << session_amount
  #   end
  #   total_amount = total_amount.map(&:to_i).reduce(:+)
  #   amount = total_amount * transaction_percentage
  #   transaction_fee = amount - total_amount
  #   charge = context.tutor.charges.create(token: context.token, customer_id: context.customer_id,
  #                                         amount: amount, transaction_fee: transaction_fee)
  #   context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
  #   context.charge = charge
  # end


end


  # Call with: tutor: instance_of Tutor
  #            appointments: array of Appointment
  #            customer_id: student.customer_id
  #            token: params[:token]
  #            rates: array of TutorCourse.rate in dollars
  #            transaction_percentage: School.transaction_percentage
  #            promotion_id: promotion.id or nil