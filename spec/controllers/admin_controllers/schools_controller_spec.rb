require 'rails_helper'

describe Admin::SchoolsController do 
  let(:school) { create(:school) }
  let(:invalid_school) { create(:invalid_school)}
  let(:school_attributes) { attributes_for(:school) }
  let(:invalid_school_attributes) { attributes_for(:school, :invalid) }
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

    it 'assigns all schools to @schools' do 
      create_list(:school, 2)
      get :index
      expect(assigns(:schools).length).to eq(2)
    end
  end

  describe 'GET #new' do 
    
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new 
    end

    it 'assigns a new school to @school' do
      get :new
      expect(assigns(:school)).to be_a_new(School)
    end
  end

  describe 'POST #create' do 

    context 'with valid attributes' do 
      
      it 'creates a new school and redirects to the school' do
        expect { 
          post :create, school: school_attributes
        }.to change(School, :count).by(1)
        expect(response).to redirect_to admin_school_path(School.last.id)
      end
    end

    context 'with invalid attributes' do 
    
      it 'does not create a new school and renders the :new template' do
        expect {
          post :create, school: invalid_school_attributes
        }.not_to change(School, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do 
    
    it 'renders the :show template' do 
      get :show, id: school
      expect(response).to render_template :show
    end

    it 'sets the correct school to @school' do 
      get :show, id: school
      expect(assigns(:school)).to eq school
    end
  end

  # Removed Edit tests because it's now done in-line on Show page

  describe 'PUT #update' do 

    context 'with valid attributes' do 
      
      it 'updates the school and redirects to the schools index' do  
        xhr :put, :update, id: school, school: {
          name: 'Test School Name',
          location: 'Test School Location'
        }
        school.reload
        expect(school.name).to eq 'Test School Name'
        expect(school.location).to eq 'Test School Location'
      end
    end

    context 'with invalid attributes' do 

      it 'does not update the school and renders the :edit page' do 
       xhr :put, :update, id: school, school: {
          name: nil,
          location: 'Invalid School Location'
        }
        school.reload
        expect(school.name).not_to eq 'Invalid School Location'
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    it 'deletes the contact and redirects to the schools index' do
      school 
      expect {
        delete :destroy, id: school
      }.to change(School, :count).by(-1)
      expect(response).to redirect_to admin_schools_path
    end
  end
end