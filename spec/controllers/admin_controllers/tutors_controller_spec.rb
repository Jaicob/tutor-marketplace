require 'rails_helper'

describe Admin::TutorsController do
  let(:student) { create(:user, :student) }
  let(:tutor) { create(:tutor, :complete_tutor) } 
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
      login_with(admin)
      get :index
      expect(response).to render_template :index
    end

    it 'assigns all tutors to @tutors' do 
      login_with(admin)
      tutor
      get :index
      expect(assigns(:tutors).count).to eq(1)
    end
  end

  describe 'GET #show' do 

    before :each do 
      login_with(admin)
    end

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

    it 'assigns the correct tutor to @tutor' do
      put :update, id: tutor.id, tutor: attributes_for(:tutor, major: 'Test Major')
      expect(assigns(:tutor)).to eq(tutor) 
    end

    it 'updates attributes for @tutor' do
      expect(tutor.major).to eq(nil)
      put :update, id: tutor.id, tutor: {major: 'Test Major'}
      tutor.reload
      expect(tutor.major).to eq('Test Major')
    end

    it 'sends the activation email when @tutor is activated' do
      expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
      expect(tutor.active_status).to eq('Inactive')
      put :update, id: tutor.id, tutor: {active_status: 'Active'}
      tutor.reload
      expect(tutor.active_status).to eq('Active')
      expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
      expect(Sidekiq::Extensions::DelayedMailer.jobs.first['args']).to have_content(':activation_email')
    end

    it 'sends the de-activation email when @tutor is de-activated' do
      expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 0
      expect(active_tutor.active_status).to eq('Active')
      put :update, id: tutor.id, tutor: {active_status: 'Inactive'}
      tutor.reload
      expect(tutor.active_status).to eq('Inactive')
      expect(Sidekiq::Extensions::DelayedMailer.jobs.count).to eq 1
      expect(Sidekiq::Extensions::DelayedMailer.jobs.first['args']).to have_content(':deactivation_email')
    end
  end

  # describe 'PATCH #update' do 

  #   it 'assigns the correct tutor to @tutor' do 
  #     login_with tutor.user
  #     xhr :patch, :update, id: tutor, tutor: attributes_for(:tutor)
  #     expect(assigns(:tutor)).to eq tutor
  #   end

  #   it 'updates attributes for @tutor' do 
  #     login_with tutor.user
  #     xhr :patch, :update, id: tutor, tutor: attributes_for(:tutor, major: 'Test Major')
  #     tutor.reload
  #     expect(tutor.major).to eq 'Test Major'
  #   end      
  # end

  describe 'DELETE #destroy' do 
  
    it "succesfully destroys the correct tutor from the admin tutors page" do
      skip
    end
  end
end


