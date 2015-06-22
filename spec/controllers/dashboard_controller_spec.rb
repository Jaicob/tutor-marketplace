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

    it "updates a tutors's major", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {major: 'Astrology'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.major).to eq('Astrology')
    end

    it "updates a tutors's degree", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {degree: 'PhD XYZ'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.degree).to eq('PhD XYZ')
    end

    it "updates a tutors's graduation_year", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {graduation_year: '2020'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.graduation_year).to eq('2020')
    end

    it "updates a tutors's extra_info", :skip_before do
      login_with tutor.user
      put :update_profile, id: tutor.user, data: {tutor: {extra_info: 'Party on Wayne'}}
      expect(response).to redirect_to profile_user_path(tutor.user)
      tutor.reload
      expect(tutor.extra_info).to eq('Party on Wayne')
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

    it "updates a user's first_name" do
      put :update_settings, id: user, data: {user: {first_name: 'Ludacris'}}
      expect(response).to redirect_to settings_user_path(user)
      user.reload
      expect(user.first_name).to eq('Ludacris')
    end

    it "updates a user's last_name" do
      put :update_settings, id: user, data: {user: {last_name: 'Hodor'}}
      expect(response).to redirect_to settings_user_path(user)
      user.reload
      expect(user.last_name).to eq('Hodor')
    end

    it "updates a user's email" do
      put :update_settings, id: user, data: {user: {email: 'new-email@example.com'}}
      expect(response).to redirect_to settings_user_path(user)
      user.reload
      expect(user.email).to eq('new-email@example.com')
    end

    it "updates a tutor's first_name", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {first_name: 'Ricky'},
        tutor: {phone_number: tutor.phone_number} # No change here, but need some tutor data to make action work
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.user.first_name).to eq('Ricky')
    end

    it "updates a tutor's last_name", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {last_name: 'Ricardo'},
        tutor: {phone_number: tutor.phone_number} # No change here, but need some tutor data to make action work
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.user.last_name).to eq('Ricardo')
    end

    it "updates a tutor's email", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {email: 'new-email@example.com'},
        tutor: {phone_number: tutor.phone_number} # No change here, but need some tutor data to make action work
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.user.email).to eq('new-email@example.com')
    end

    it "updates a tutor's birthdate", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {email: tutor.user.email },
        tutor: {birthdate: Date.today }
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.birthdate).to eq(Date.today)
    end

    it "updates a tutor's phone_number", :skip_before do
      login_with tutor.user
      put :update_settings, id: tutor.user, data: {
        user: {email: tutor.user.email },
        tutor: {phone_number: '333-333-3333' }
      }
      expect(response).to redirect_to settings_user_path(tutor.user)
      tutor.reload
      expect(tutor.phone_number).to eq('333-333-3333')
    end 

  end

end

