require 'rails_helper'

describe TutorsController do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe 'GET #new' do

    it "assigns a new Tutor to @tutor" do 
      get :new
      expect(assigns(:tutor)).to be_a_new(Tutor)
    end

    it "it renders the :new template" do
      get :new 
      expect(response).to render_template :new
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
        expect(response).to redirect_to dashboard_user_path(user)
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
        expect(response).to redirect_to register_or_sign_in_tutor_path(@tutor.id)
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
      tutor = create(:tutor) 
      get :register_or_sign_in, {id: tutor.id}
      expect(response).to render_template :register_or_sign_in
    end 
  end

  describe 'GET  #visitor_sign_in' do
    it "renders the visitor_sign_in template" do 
      tutor = create(:tutor)
      get  :visitor_sign_in, {id: tutor.id}
      expect(response).to render_template :visitor_sign_in
    end
  end


  describe 'GET #visitor_sign_up' do 
    it "renders the visitor_sign_up template" do
      tutor = create(:tutor)
      get :visitor_sign_up, {id: tutor.id}
      expect(response).to render_template :visitor_sign_up
    end
  end

end

