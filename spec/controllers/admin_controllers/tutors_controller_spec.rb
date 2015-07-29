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


