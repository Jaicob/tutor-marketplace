require 'rails_helper'

RSpec.describe CheckoutOrganizer do

  describe 'CheckoutOrganizer' do

    before :each do 

    end

    it 'runs succesfully with no promotion' do 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: 'tok_fake124223223',
        appts_info: [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}],
        promotion_id:
      }
      context = CheckoutOrganizer.call(params)

    end
  end
end

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)