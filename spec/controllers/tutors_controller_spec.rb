require 'rails_helper'


####

# All tests here are setup and passing except the post requests, both #create and #visitor_create
# To finish this spec, those requests need to be tested with both valid and invalid attributes for creation  

####


describe TutorsController do
  let(:user) { create(:user) }

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
      it "saves the new tutor in the database" do
        skip "works in app, but haven't figured out how to correctly write this test yet"
        sign_in(user)
        expect {
          post :create, tutor: attributes_for(:tutor)
        }.to change(Tutor, :count).by(1)
      end

      it "redirects to the tutor's dashboard" do
        skip "works in app, but haven't figured out how to correctly write this test yet"
        sign_in(user)
        post :create, tutor: FactoryGirl.attributes_for(:tutor)
        expect(response).to redirect_to dashboard_courses_tutor_path(assigns[:tutor]) 
      end

    end

    context "with invalid attributes" do
      it "does not save the new tutor in the database" do 
      end

      it "re-renders the :new template" do 
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
    end

    context "with invalid attributes" do 
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

