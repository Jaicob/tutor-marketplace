require 'rails_helper'

describe Admin::TutorsController do
  let(:tutor) { create(:tutor) } 
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do 

    it 'renders the :index template' do
      get :index
      expect(response).to render_template :index 
    end

    it 'assigns all tutors to @tutors' do 
      create_list(:tutor, 2)
      get :index
      expect(assigns(:tutors).length).to eq(2)
    end
  end

  describe 'PATCH #update_active_status' do 
  
    it "updates a tutor's active status" do
      skip
    end

    it "sends the activation email when status is changed to active" do
      skip
    end

    it "sends the activation email when status is changed to active" do
      skip
    end
  end

  describe 'PATCH #destroy_by_admin' do 
  
    it "succesfully destroys the correct tutor from the admin tutors page" do
      login_with admin
      tutor
      expect{
        xhr :patch, :destroy_by_admin, id: tutor.id
        }.to change(Tutor, :count).by(-1)
    end
  end
end