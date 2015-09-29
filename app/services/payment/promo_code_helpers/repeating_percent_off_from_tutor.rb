module PromoCodeHelpers
  class RepeatingPercentOffFromTutor


#  category         :integer    :repeating_percent_off_from_tutor / :repeating_dollar_amount_off_from_tutor
#  amount           :integer    percent-off / dollar-amount
#  valid_from       :date              
#  valid_until      :date
#  redemption_limit :integer    nil
#  redemption_count :integer          default(0)
#  description      :text

# Apply discount in similar fashion as non-repeating dollar_amount_off_from_tutor and percent_off_from_tutor promos, except:
# -do not increment redemption_count
# -validate that discount is only applied to appropriate course(s)
#     -how?
#     -to get class from context
#         -context.appointments & appointments have course_id
#     -to store classes on promotion
#         -
#         -

    # attr_accessor :charge

    # def initialize(context)
    #   @context = context
    #   @charge = context.charge
    #   @amount = @charge.amount
    #   @promotion = Promotion.find(context.promotion_id)
    #   @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
    #   @rates = context.rates
    #   @is_payment_required = context.is_payment_required
    #   @tutor = context.tutor
    # end

    # def return_adjusted_fees
    #   if is_redemption_valid?(@promotion, @tutor)
    #     @promotion.redemption_count += 1
    #     @promotion.save
    #   else
    #     puts 'Promo code is invalid'
    #     return 
    #   end
    #   update_charge(@context, @charge, @rates, @transaction_fee, @promotion)
    #   return @context
    # end

    # def is_redemption_valid?(promotion, tutor)
    #   (promotion.redemption_count < promotion.redemption_limit) && 
    #   (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) &&
    #   (promotion.tutor_id == tutor.id) ? 
    #   true : false
    # end

    # def update_charge(context, charge, rates, transaction_fee, promotion)
    #   if rates.count == 1
    #     charge.update(
    #       amount: 0,
    #       tutor_fee: 0,
    #       axon_fee: 0,
    #       promotion_id: promotion.id
    #     )
    #     @is_payment_required = false
    #   else
    #     rates.sort!.slice!(0) # rates minus the lowest rate
    #     rates_total = rates.reduce(:+)
    #     new_amount = rates_total * transaction_fee * 100
    #     new_tutor_fee = rates_total * 100
    #     new_axon_fee = new_amount - (new_tutor_fee)
    #     charge.update(
    #       amount: new_amount,
    #       tutor_fee: new_tutor_fee,
    #       axon_fee: new_axon_fee,
    #       promotion_id: promotion.id
    #     )
    #   end
    # end

  end
end