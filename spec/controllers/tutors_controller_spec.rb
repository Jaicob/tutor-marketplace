require 'rails_helper'

describe TutorsController do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:tutor) { create(:tutor) }

  describe 'GET #show' do 
  
    it "assigns the correct tutor to @tutor" do
      get :show, id: tutor.user
      expect(assigns(:tutor)).to eq tutor
    end

    it "renders the :show template" do 
      get :show, id: tutor.user
      expect(response).to render_template :show
    end
  end

end