require 'rails_helper'

describe Admin::AppointmentsController do
  let(:appointment) { create(:appointment) }
  let(:super_admin) { create(:user, :super_admin) }

  before :each do 
    login_with super_admin
  end

  describe 'GET #index' do 

    it 'renders the :index template' do
      get :index
      expect(response).to render_template :index 
    end
  end

  describe 'PUT #update' do 

    it 'sends the correct email when an appt is updated' do
      skip "can't get complex association of factories to pass validation for tutor, student and course to be at same school "
    end

    it 'sends the correct email when an appt is cancelled' do 
      skip "can't get complex association of factories to pass validation for tutor, student and course to be at same school "
    end
  end

end