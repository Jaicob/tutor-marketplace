require 'rails_helper'

describe AdminController do 

  describe 'GET #tutors' do 
    it "assings all tutors to @tutors" do
       
    end

    it "renders the :tutors template" do 
      get :tutors
      expect(response).to render_template :tutors
    end
  end


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



end

