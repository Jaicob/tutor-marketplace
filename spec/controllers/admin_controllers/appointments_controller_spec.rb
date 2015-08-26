require 'rails_helper'

describe Admin::AppointmentsController do 
  let(:student) { create(:user, :student) }
  let(:tutor) { create(:tutor, :complete_tutor) } 
  let(:admin) { create(:user, :super_admin) }

  describe 'GET #index' do 

    it 'redirects to root_path for visitors/non-signed-in users' do
      get :index
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to dashboard_home for signed-in students' do
      login_with(student)
      get :index
      expect(response).to redirect_to(dashboard_home_user_path(student))
    end

    it 'renders the :index template for signed-in admin' do
      login_with(admin)
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

