require 'rails_helper'

describe Dashboard::ProfileController do 
  let(:user) { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  # This makes sure a user is logged in for each test. Except in tests where a tutor is necessary, a simple user without a tutor is used. Where a tutor is necessary, :login_with_tutor is added to the 'it' method as metadata.
  before :each do |example|
    if example.metadata[:login_with_tutor]
      login_with tutor.user
    else
      login_with user
    end
  end

  describe 'GET #index' do 

    it "renders the :index template" do 
      get :index, id: user
      expect(response).to render_template :index
    end

    it "assigns the current user to @user" do 
      get :index, id: user
      expect(assigns(:user)).to eq user
    end 

    it "assigns @tutor to user's tutor", :login_with_tutor do
      get :index, id: tutor.user
      expect(assigns(:tutor)).to eq tutor
    end
  end

  describe 'GET #edit' do 

    it "renders the :edit template" do 
      get :edit, id: user
      expect(assigns(:user)).to eq user
    end

    it "assigns the current user to @user" do 
      get :edit, id: user
      expect(assigns(:user)).to eq user
    end 

    it "assigns @tutor to user's tutor", :login_with_tutor do
      get :edit, id: user
      expect(assigns(:tutor)).to eq tutor
    end
  end
end