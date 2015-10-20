module PromoCodeHelpers
  class RepeatingPercentOffFromTutor


    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @promotion = Promotion.find(context.promotion_id)
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @rates = context.rates
      @tutor = context.tutor
      @appointments = context.appointments
      @eligible_appts = @appointments.select{|appt| appt.course_id == @promotion.course_id}
    end

    def return_adjusted_fees
      return false unless @promotion.category == 'repeating_percent_off_from_tutor'
      if is_redemption_valid?(@promotion, @tutor)
        if @eligible_appts.count > 0
          find_discount_price_difference(@promotion, @appointments, @eligible_appts, @rates, @transaction_fee)
        else
          puts 'Promo code is invalid for selected courses.'
          return
        end
      else
        puts 'Promo code is invalid. It has reached its redemption limit, expired, or only applies to a different tutor.' 
        return 
      end
      update_charge(@charge, @discount_amount, @transaction_fee, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion, tutor)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) &&
      (promotion.tutor_id == tutor.id) ? 
      true : false
    end

    def find_discount_price_difference(promotion, appointments, eligible_appts, rates, transaction_fee)
      rates_total = rates.map(&:to_i).reduce(:+)
      regular_rate_for_eligible_appts = @eligible_appts.map(&:tutor_rate).reduce(:+)
      discount_multiplier = ((promotion.amount.to_f / 100) - 1).abs
      discount_rate_for_eligible_appts = regular_rate_for_eligible_appts * discount_multiplier
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