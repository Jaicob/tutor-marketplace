require 'rails_helper'

describe DashboardController do
  let(:user) { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  # before :each do
  #   login_with user
  # end

  before :each do |example|
    unless example.metadata[:skip_before]
      login_with user
    end
  end

  describe 'GET #home' do

    it "renders the :home template" do
      get :home, id: user
      expect(response).to render_template :home
    end

    it "assigns the current user to @user" do 
      get :home, id: user
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #schedule' do

    it "renders the :schedule template" do 
      get :schedule, id: user
      expect(response).to render_template :schedule
    end

    it "assigns the current user to @user" do 
      get :schedule, id: user
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #courses' do 

    it "renders the :courses template" do
      get :courses, id: user
      expect(response).to render_template :courses
    end

    it "assigns the current user to @user" do 
      get :courses, id: user
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #profile' do

    it "renders the :profile template" do
      get :profile, id: user
      expect(response).to render_template :profile
    end

    it "assigns the current user to @user" do 
      get :profile, id: user
      expect(assigns(:user)).to eq user
    end 
  end

  describe 'PUT #update_profile' do

    it "updates a tutors's profile settings", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {major: 'Astrology'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.major).to eq('Astrology')
    end
  end

  describe 'PUT #change_profile_pic' do
  end

  describe 'PUT #save_profile_pic' do 
  end

  describe 'GET #settings' do 

    it "renders the :settings template" do
      get :settings, id: user
      expect(response).to render_template :settings
    end

    it "assigns the current user to @user" do 
      get :settings, id: user
      expect(assigns(:user)).to eq user
    end 
  end

  describe 'PUT #update_settings' do 
  end

end

