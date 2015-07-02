require 'rails_helper'

describe TutorsController do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:tutor_stub) { build_stubbed(:tutor) }
  let(:tutor) { create(:complete_tutor) }
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do 
    it 'renders the :index template' do 
      get :index
      expect(response).to render_template :index
    end

    it 'assings all tutors to @tutors' do 
      tutor
      second_tutor = create(:second_complete_tutor)
      get :index
      expect(assigns(:tutors)).to eq ([tutor, second_tutor])
    end
  end

  describe 'GET #new' do

    it "assigns a new Tutor to @tutor" do 
      get :new
      expect(assigns(:tutor)).to be_a_new(Tutor)
    end

    it "renders the :new template" do
      get :new 
      expect(response).to render_template :new
    end
  end

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

  describe 'POST #create' do

    context "with valid attributes" do 
      
      it "creates a new tutor then redirects to tutor's dashboard" do
        login_with user
        course
        expect {
          post :create, {
            tutor: attributes_for(:tutor),
            course: {course_id: course.id},
            tutor_course: {rate: 25}
          }
        }.to change(Tutor, :count).by(1)
        expect(response).to redirect_to dashboard_home_user_path(user)
      end
    end

    context "with invalid attributes" do

      it "does not create a new tutor and then re-renders the :new template" do 
        login_with user
        course
        expect {
          post :create, {
            tutor: attributes_for(:invalid_tutor),
            course: {course_id: course.id},
            tutor_course: {rate: 25}
          }
        }.not_to change(Tutor, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do

    context 'for logged in tutor' do  

      it 'renders the :edit template' do
        login_with tutor.user
        get :edit, id: tutor.user
        expect(response).to render_template :edit
      end

      it 'assigns the correct tutor to @tutor' do
        login_with tutor.user
        get :edit, id: tutor.user
        expect(assigns(:tutor)).to eq tutor
      end
    end

    context 'for non-logged in tutor' do 
      it 'redirects to tutors_path' do
        skip 'need to figure out how to test this -- restricted access'
      end
    end

  end

  describe 'PATCH #update' do 

    it 'assigns the correct tutor to @tutor' do 
      login_with tutor.user
      xhr :patch, :update, id: tutor, tutor: attributes_for(:tutor)
      expect(assigns(:tutor)).to eq tutor
    end

    it 'updates attributes for @tutor' do 
      login_with tutor.user
      xhr :patch, :update, id: tutor, tutor: attributes_for(:tutor, major: 'Test Major')
      tutor.reload
      expect(tutor.major).to eq 'Test Major'
    end      
  end

  describe 'DELETE #destroy' do 
    
    it 'assigns the correct tutor to @tutor' do 
      login_with tutor.user
      delete :destroy, id: tutor.user
      expect(assigns(:tutor)).to eq tutor
    end

    it 'deletes @tutor and redirects to dashboard/home' do 
      tutor
      login_with tutor.user
      user = tutor.user
      expect{
        delete :destroy, id: tutor.user
      }.to change(Tutor, :count).by(-1)
      expect(response).to redirect_to(dashboard_home_user_path(user))
    end
  end


  #==================================================
  # Custom Non-RESTful actions below
  #==================================================

  describe 'PATCH #update_active_status' do 
  
    it "updates a tutor's active status" do 
      skip "need to figure out how to make this work - functionality is OK but test doesn't work because need to pass in extra id param and cant do it here"
      login_with admin
      xhr :patch, :update, id: admin, tutor: attributes_for(:tutor, active_status: 'Active')
      tutor.reload
      expect(tutor.active_status).to eq 'Active'
      xhr :patch, :update, id: admin, tutor: attributes_for(:tutor, active_status: 'Inactive')
      tutor.reload
      expect(tutor.active_status).to eq 'Inactive'
    end

    it "sends the activation email when status is changed to active" do
    end

    it "sends the activation email when status is changed to active" do
    end

  end

  describe 'GET #visitor_new' do

     it "assigns a new Tutor to @tutor" do 
      get :visitor_new
      expect(assigns(:tutor)).to be_a_new(Tutor)
    end

    it "it renders the :new template" do
      get :visitor_new
      expect(response).to render_template :visitor_new
    end
  end

  describe 'POST #visitor_create' do 

    context "with valid attributes" do 

      it "creates a new tutor then redirects to :register_or_sign_in" do
        course
        expect {
          post :visitor_create, {
            tutor: attributes_for(:tutor),
            course: {course_id: course.id},
            tutor_course: {rate: 25}
          }
        }.to change(Tutor, :count).by(1)
        expect(response).to redirect_to register_or_sign_in_tutor_path(Tutor.last.id)
      end
    
    end

    context "with invalid attributes" do 

      it "doesn't create a tutor and renders :visitor_new" do
        course
        expect {
          post :visitor_create, {
            tutor: attributes_for(:invalid_tutor),
            course: {course_id: course.id},
            tutor_course: {rate: 25}
          }
        }.to_not change(Tutor, :count)
        expect(response).to render_template :visitor_new
      end
    end
  
  end

  describe 'GET #register_or_sign_in' do 
    it "renders the register_or_sign_in template" do
      get :register_or_sign_in, {id: tutor_stub.id}
      expect(response).to render_template :register_or_sign_in
    end 
  end

  describe 'GET  #visitor_sign_in' do
    it "renders the visitor_sign_in template" do 
      get  :visitor_sign_in, {id: tutor_stub.id}
      expect(response).to render_template :visitor_sign_in
    end
  end

  describe 'GET #visitor_sign_up' do 
    it "renders the visitor_sign_up template" do
      get :visitor_sign_up, {id: tutor_stub.id}
      expect(response).to render_template :visitor_sign_up
    end
  end

end

