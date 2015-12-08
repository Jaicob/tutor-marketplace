class CreateCharge
  include Interactor
  
  ##
  # Call with: tutor_id: tutor_id
  #       appointments: array of appt_ids
  #       student_id: student_id
  #       promotion_id: promotion.id (or nil)

  ##
  # Charge attributes
  #       id               :integer          not null, primary key
  #       amount           :float
  #       axon_fee         :float
  #       tutor_fee        :float
  #       tutor_id         :integer
  #       token            :string
  #       created_at       :datetime         not null
  #       updated_at       :datetime         not null
  #       promotion_id     :integer
  #       student_id       :integer
  #       stripe_charge_id :string

  def call
    begin 
      @tutor = Tutor.find(context.tutor_id)
      @student = Student.find(context.student_id)

      context.transaction_percentage = School.find(@tutor.id).transaction_percentage
      axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)

      tutor_rates = []

      context.appointments.each do |appt|
        rate = TutorCourse.where(tutor_id: @tutor.id, course_id: appt.course_id).first.rate

        appt.course_id
        session_amount = (rate * 100)
        tutor_rates << session_amount
      end

      # rate_array = []
      # context.appointments.count.times { rate_array << rate }

      tutor_fee = tutor_rates.map(&:to_i).reduce(:+)
      amount = tutor_fee * axon_fee_multiplier
      axon_fee = amount - tutor_fee

      charge = @tutor.charges.create(
        student_id: @student.id,
        amount: amount,
        axon_fee: axon_fee,
        tutor_fee: tutor_fee
      )

      context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
      context.charge = charge
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
      puts "THIS WAS CALLED IN CREATECHARGE!"
    end
  end

end