require 'rails_helper'

describe DashboardController do
  let(:user) { create(:user) }
  let(:tutor) { create(:complete_tutor) }

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

    it "updates a tutors's profile", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {major: 'Astrology'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.major).to eq('Astrology')
    end
  end

  describe 'PUT #change_profile_pic' do
    skip 'not sure how to test this yet'
  end

  describe 'PUT #save_profile_pic_crop' do
    skip 'not sure how to test this yet' 
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

    it "updates a user's settings" do
      put :update_settings, id: user, data: {user: {first_name: 'Ludacris'}}
      expect(response).to redirect_to settings_user_path(user)
      user.reload
      expect(user.first_name).to eq('Ludacris')
    end 

     it "updates a tutors's profile", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {major: 'Astrology'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.major).to eq('Astrology')
    end

    it "updates a tutors's settings on user model", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {last_name: 'Ricardo'},
        tutor: {phone_number: tutor.phone_number} # No change here, but need some tutor data to make action work
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.user.last_name).to eq('Ricardo')
    end

    it "updates a tutors's settings on tutor model", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
          user: {first_name: tutor.user.first_name }, # No change here, but need some user data to make action work
          tutor: {phone_number: '0000000000'}
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.phone_number).to eq('0000000000')
    end

  end

end

