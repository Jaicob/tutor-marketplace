require 'rails_helper'

describe Admin::CoursesController do 
  let(:course) { create(:course) }
  let(:invalid_course) { create(:invalid_course)}
  let(:course_attributes) { attributes_for(:course, school_id: school.id) }
  let(:invalid_course_attributes) { attributes_for(:invalid_course) }
  let(:school) { create(:school) }
  let(:student) { create(:user, :student) }
  let(:tutor) { create(:tutor, :complete_tutor) } 
  let(:admin) { create(:user, :super_admin) }

  describe 'GET #index' do 

    it 'denies access and redirects to root_path for visitors/non-signed-in users' do
      get :index
      expect(response).to redirect_to(root_path)
    end

    it 'denies access and redirects to dashboard_home for signed-in students' do
      login_with(student)
      get :index
      expect(response).to redirect_to(dashboard_home_user_path(student))
    end

    it 'renders the :index template for signed-in admin' do
      login_with(admin)
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do 
    
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new 
    end

    it 'assigns a new course to @course' do
      get :new
      expect(assigns(:course)).to be_a_new(Course)
    end
  end

  describe 'POST #create' do 

    context 'with valid attributes' do 
      
      it 'creates a new course and redirects to the course' do
        expect { 
          post :create, course: course_attributes
        }.to change(Course, :count).by(1)
        expect(response).to redirect_to(admin_course_path(Course.last.id))
      end
    end

    context 'with invalid attributes' do 
    
      it 'does not create a new course and renders the :new template' do
        expect {
          post :create, course: invalid_course_attributes
        }.not_to change(Course, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do 
    
    it 'renders the :show template' do 
      get :show, id: course
      expect(response).to render_template :show
    end

    it 'sets the correct course to @course' do 
      get :show, id: course
      expect(assigns(:course)).to eq course
    end
  end

  describe 'PUT #update' do 

    context 'with valid attributes' do 
      
      it 'updates the course and redirects to the course' do
        xhr :put, :update, id: course, course: {
          call_number: course.call_number,
          friendly_name: 'Test Name',
          school_id: course.school,
          subject: course.subject
        }
        course.reload
        expect(course.friendly_name).to eq 'Test Name'
        expect(response).to redirect_to admin_course_path(course)
      end
    end

    context 'with invalid attributes' do 

      it 'does not update the course and renders the :edit page' do 
       xhr :put, :update, id: course, course: {
          call_number: course.call_number,
          friendly_name: nil,
          school_id: course.school,
          subject: course.subject
        }
        course.reload
        expect(course.friendly_name).not_to eq 'Test Name'
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    it 'deletes the contact and redirects to the courses index' do
      course 
      expect {
        delete :destroy, id: course
      }.to change(Course, :count).by(-1)
      expect(response).to redirect_to admin_courses_path
    end
  end
end