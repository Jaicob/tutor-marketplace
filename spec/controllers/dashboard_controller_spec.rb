require 'rails_helper'

describe DashboardController do 

  describe 'GET #home' do
    it "assigns the current tutor to @tutor" do
      tutor = create(:tutor)
      get :home
      expect(assigns(:tutor)).to eq tutor
    end 

    it "renders the :home template" do 
      get :home
      expect(response).to render_template :home
    end
  end

  # dashboard_user GET    /:id/dashboard(.:format)                  dashboard#home
  # The problem here is that this is a nested route under users, maybe change to scope or figure out how to test this?

  describe 'GET #schedule' do 
  end

  describe 'GET #courses' do 
  end

  describe 'GET #profile' do 
  end

  describe 'PUT #update_profile' do 
  end

  describe 'PUT #change_profile_pic' do
  end

  describe 'PUT #save_profile_pic' do 
  end

  describe 'GET #settings' do 
  end

  describe 'PUT #update_settings' do 
  end

end

