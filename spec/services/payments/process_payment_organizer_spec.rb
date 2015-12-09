require 'rails_helper'

RSpec.describe CheckoutOrganizer do

  before(:context) do 
    @test = SecureRandom.hex(5)
  end


  describe 'CheckoutOrganizer with no promotion' do

    it 'runs succesfully with no promotion' do 
      # params = {
      #   tutor_id: @tutor.id,
      #   student_id: @student.id,
      #   stripe_token: 'tok_fake124223223',
      #   appts_info: [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}],
      #   promotion_id: 1
      # }
      # context = CheckoutOrganizer.call(params)
      puts "1 #{@test}"
    end

    it "uses the same number" do 
      puts "2 #{@test}"
    end

  end
end

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)