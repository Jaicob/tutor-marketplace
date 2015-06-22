require 'rails_helper'

describe AdminController do 

  describe 'GET #tutors' do
    let(:tutor) { create(:tutor) } 

    it "renders the :tutors template" do 
      get :tutors
      expect(response).to render_template :tutors
    end
    
    it "assings all tutors to @tutors" do
      tutor
      get :tutors
      expect(assigns(:tutors)).to eq([tutor])
    end
    
  end

end
