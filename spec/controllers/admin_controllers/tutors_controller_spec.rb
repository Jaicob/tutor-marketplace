require 'rails_helper'

describe Admin::TutorsController do
  let(:tutor) { create(:tutor) } 
  let(:) {}
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

    end

    it 'assigns all tutors to @tutors' do 
      create_list(:tutor, 2)
      get :index
      expect(assigns(:tutors).length).to eq(2)
    end
  end

  describe 'GET #show' do 

    it 'renders the :show template' do 
      get :show, id: tutor.id
      expect(response).to render_template :show
    end

    it 'assings the correct tutor to @tutor' do 
      get :show, id: tutor.id
      expect(assigns(:tutor)).to eq(tutor)
    end
  end

  describe 'GET #update' do
  end


  describe 'DELETE #destroy' do 
  
    it "succesfully destroys the correct tutor from the admin tutors page" do
      skip
    end
  end
end


