module PromoCodeHelpers
  class RepeatingDollarAmountOffFromTutor

# Apply discount in similar fashion as non-repeating dollar_amount_off_from_tutor and percent_off_from_tutor promos, except:
# -do not increment redemption_count
# -validate that discount is only applied to appropriate course(s)

    attr_accessor :charge, :appointments

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @promotion = Promotion.find(context.promotion_id)
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @rates = context.rates
      @tutor = context.tutor
      @appointments = context.appointments
      # puts "COURSE ID ON PROMOTION? = #{@promotion.methods.include?(:course_id)}"
      @eligible_appts = @appointments.select{|appt| appt.course_id == @promotion.course_id}
      puts "@eligible_appts!!!!!!!! = #{@eligible_appts}"
      # @eligible_appts = @appointments.select{|appt| appt.course_id == @promotion.course_id}
    end

    def return_adjusted_fees
      if is_redemption_valid?(@promotion, @tutor)
        find_discount_price_difference(@promotion, @appointments, @eligible_appts, @rates)
      else
        puts 'Promo code is invalid'
        return 
      end
      update_charge(@charge, @amount, @rates, @transaction_fee, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion, tutor)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) &&
      (promotion.tutor_id == tutor.id) ? 
      true : false
    end

    def find_discount_price_difference(promotion, appointments, eligible_appts, rates)
      # puts "@eligible_appts!!!!!!!!!!!!! = #{@eligible_appts}"
      rates_total = rates.map(&:to_i).reduce(:+)
      regular_rate_for_eligible_appts = @eligible_appts.map(&:tutor_rate).reduce(:+)
      # puts "appointments = #{appointments}"
      puts "eligible_apptsXxXXXXXX = #{eligible_appts}"
      # puts "regular_rate_for_eligible_appts = #{regular_rate_for_eligible_appts}"
      discount_rate_for_eligible_appts = regular_rate_for_eligible_appts - (eligible_appts.count * promotion.amount.to_i)
      rates_total_with_discount = rates_total - regular_rate_for_eligible_appts + discount_rate_for_eligible_appts
      @discount_amount = rates_total_with_discount * transaction_fee * 100
    end

    def update_charge(charge, discount_amount, transaction_fee, promotion)
      new_amount = discount_amount
      new_tutor_fee = (new_amount.to_f / transaction_fee).to_i
      new_axon_fee = new_amount - new_tutor_fee
      charge.update(
        amount: new_amount,
        tutor_fee: new_tutor_fee,
        axon_fee: new_axon_fee,
        promotion_id: promotion.id
      )
    end

  end
end