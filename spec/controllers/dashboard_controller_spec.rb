require 'rails_helper'

describe DashboardController do
  let(:user) { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  # This before action is skipped on tests where the Tutor model (rather than just the User model) is affected because the two must be linked together on those, so 'login_with tutor.user'is called on the first line of those specs
  before :each do |example|
    unless example.metadata[:skip_first_before]
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

    context 'when a user has a tutor account' do
    
      it "assigns @tutor to user's tutor" do
        get :home, id: user
        expect(assigns(:tutor)).to eq user.tutor
      end
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
  
    it "assigns @tutor to user's tutor" do
      get :schedule, id: user
      expect(assigns(:tutor)).to eq user.tutor
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

    it "assigns @tutor to user's tutor" do
      get :courses, id: user
      expect(assigns(:tutor)).to eq user.tutor
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

    it "assigns @tutor to user's tutor" do
      get :profile, id: user
      expect(assigns(:tutor)).to eq user.tutor
    end
  end

  # describe 'PUT #update_profile' do

  #   it "updates a tutors's major", :skip_first_before do
  #     login_with tutor.user
  #     put :update_profile, id: tutor.user, data: {tutor: {major: 'Astrology'}}
  #     expect(response).to redirect_to profile_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.major).to eq('Astrology')
  #   end

  #   it "updates a tutors's degree", :skip_first_before do
  #     login_with tutor.user
  #     put :update_profile, id: tutor.user, data: {tutor: {degree: 'PhD XYZ'}}
  #     expect(response).to redirect_to profile_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.degree).to eq('PhD XYZ')
  #   end

  #   it "updates a tutors's graduation_year", :skip_first_before do
  #     login_with tutor.user
  #     put :update_profile, id: tutor.user, data: {tutor: {graduation_year: '2020'}}
  #     expect(response).to redirect_to profile_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.graduation_year).to eq('2020')
  #   end

  #   it "updates a tutors's extra_info", :skip_first_before do
  #     login_with tutor.user
  #     put :update_profile, id: tutor.user, data: {tutor: {extra_info: 'Party on Wayne'}}
  #     expect(response).to redirect_to profile_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.extra_info).to eq('Party on Wayne')
  #   end
  # end

  # describe 'PUT #change_profile_pic' do
  #   skip 'not sure how to test this yet'
  # end

  # describe 'PUT #save_profile_pic_crop' do
  #   skip 'not sure how to test this yet' 
  # end

  describe 'GET #settings' do 

    it "renders the :settings template" do
      get :settings, id: user
      expect(response).to render_template :settings
    end

    it "assigns the current user to @user" do 
      get :settings, id: user
      expect(assigns(:user)).to eq user
    end 

    it "assigns @tutor to user's tutor" do
      get :settings, id: user
      expect(assigns(:tutor)).to eq user.tutor
    end
  end

  # describe 'PUT #update_settings' do

  #   it "updates a user's first_name" do
  #     put :update_settings, id: user, data: {user: {first_name: 'Ludacris'}}
  #     expect(response).to redirect_to settings_user_path(user)
  #     user.reload
  #     expect(user.first_name).to eq('Ludacris')
  #   end

  #   it "updates a user's last_name" do
  #     put :update_settings, id: user, data: {user: {last_name: 'Hodor'}}
  #     expect(response).to redirect_to settings_user_path(user)
  #     user.reload
  #     expect(user.last_name).to eq('Hodor')
  #   end

  #   it "updates a user's email" do
  #     put :update_settings, id: user, data: {user: {email: 'new-email@example.com'}}
  #     expect(response).to redirect_to settings_user_path(user)
  #     user.reload
  #     expect(user.email).to eq('new-email@example.com')
  #   end

  #   it "updates a tutor's first_name", :skip_first_before do
  #     login_with tutor.user
  #     put :update_settings, id: tutor.user, data: {
  #       user: {first_name: 'Ricky'},
  #     }
  #     expect(response).to redirect_to settings_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.user.first_name).to eq('Ricky')
  #   end

  #   it "updates a tutor's last_name", :skip_first_before do
  #     login_with tutor.user
  #     put :update_settings, id: tutor.user, data: {
  #       user: {last_name: 'Ricardo'}
  #     }
  #     expect(response).to redirect_to settings_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.user.last_name).to eq('Ricardo')
  #   end

  #   it "updates a tutor's email", :skip_first_before do
  #     login_with tutor.user
  #     put :update_settings, id: tutor.user, data: {
  #       user: {email: 'new-email@example.com'}
  #     }
  #     expect(response).to redirect_to settings_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.user.email).to eq('new-email@example.com')
  #   end

  #   it "updates a tutor's birthdate", :skip_first_before do
  #     login_with tutor.user
  #     put :update_settings, id: tutor.user, data: {
  #       tutor: {birthdate: Date.today }
  #     }
  #     expect(response).to redirect_to settings_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.birthdate).to eq(Date.today)
  #   end

  #   it "updates a tutor's phone_number", :skip_first_before do
  #     login_with tutor.user
  #     put :update_settings, id: tutor.user, data: {
  #       tutor: {phone_number: '333-333-3333' }
  #     }
  #     expect(response).to redirect_to settings_user_path(tutor.user)
  #     tutor.reload
  #     expect(tutor.phone_number).to eq('333-333-3333')
  #   end 
  # end

  describe 'GET #tutors' do

    it "renders the :tutors template for admin users" do 
      get :tutors, id: user
      expect(response).to render_template :tutors
    end

    it "does not allow access to non-admin" do
      skip 'need to settle on how to designate admins before this can be tested'
    end
    
    it "assings all tutors to @tutors" do
      tutor
      second_tutor = create(:second_complete_tutor)
      get :tutors, id: user
      expect(assigns(:tutors)).to eq([tutor, second_tutor])
    end
  end

  # describe 'PUT #update_tutor_active_status' do

  #   it "allows an admin user to activate an inactive tutor" do 
  #     skip 'still working to make this work...work'
  #     tutor
  #     put :update_tutor_active_status, id: user, tutor_id: "#{tutor.id}", active_status: 'Active'
  #     expect(response).to redirect_to tutors_user_path(user)
  #     expect(@tutors).to eq tutor
  #   end

  #   it "allows an admin user to deactivate an active tutor" do
  #   end

  #   it "does not allow a non-admin user to activate an inactive tutor" do 
  #   end

  #   it "does not allow a non-admin user to deactivate an active tutor" do
  #   end

  # end

  # describe 'DELETE #destroy_tutor' do 
  # end

end