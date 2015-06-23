require 'rails_helper'

describe CoursesController do 
  let(:course) { create(:course) }
  let(:invalid_course) { create(:invalid_course)}
  let(:subject) { create(:subject) }
  let(:school) { create(:school) }
  let(:course_attributes) { attributes_for(:course, subject_id: subject.id, school_id: school.id ) }
  let(:invalid_course_attributes) { attributes_for(:invalid_course) }
  let(:second_course) { create(:second_course)}


  describe 'GET #index' do 
    
    it 'renders the :index template' do 
      get :index
      expect(response).to render_template :index
     end

    it 'assigns all courses to @courses' do 
      course
      second_course
      get :index
      expect(assigns(:courses)).to eq([course, second_course])
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
      
      it 'creates a new course and redirects to the courses index' do
        expect { 
          post :create, course: course_attributes
        }.to change(Course, :count).by(1)
        expect(response).to redirect_to(courses_path)
      end
    end

    context 'with invalid attributes' do 
    
      it 'does not create a new course and renders the :new template' do
        create(:school)
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

  describe 'GET #edit' do 
    
    it 'renders the :edit template' do 
      get :edit, id: course
      expect(response).to render_template :edit
    end

    it 'sets the correct course to @course' do 
      get :edit, id: course
      expect(assigns(:course)).to eq course
    end
  end

  describe 'PUT #update' do 

    it 'sets the correct course to @course' do 
      put :update, id: course, course: {
        call_number: course.call_number,
        friendly_name: course.friendly_name,
        school_id: course.school,
        subject_id: course.subject
      }
      expect(assigns(:course)).to eq course
    end

    context 'with valid attributes' do 
      
      it 'updates the course and redirects to the courses index' do
        put :update, id: course, course: {
          call_number: course.call_number,
          friendly_name: 'Test Name',
          school_id: course.school,
          subject_id: course.subject
        }
        course.reload
        expect(course.friendly_name).to eq 'Test Name'
        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid attributes' do 

      it 'does not update the course and renders the :edit page' do 
       put :update, id: course, course: {
          call_number: course.call_number,
          friendly_name: nil,
          school_id: course.school,
          subject_id: course.subject
        }
        course.reload
        expect(course.friendly_name).not_to eq 'Test Name'
      end
    end
  end

  describe 'DELETE #destroy' do

      it 'deletes the contact and redirects to the courses index' do
        course 
        expect {
          delete :destroy, id: course
        }.to change(Course, :count).by(-1)
        expect(response).to redirect_to courses_path
      end

  end



 

end