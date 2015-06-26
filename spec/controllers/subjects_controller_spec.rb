require 'rails_helper'

describe SubjectsController do 
  let(:subject) { create(:subject) }
  let(:invalid_subject) { create(:invalid_subject)}
  let(:subject_attributes) { attributes_for(:subject) }
  let(:invalid_subject_attributes) { attributes_for(:invalid_subject) }

  describe 'GET #index' do 
    
    it 'renders the :index template' do 
      get :index
      expect(response).to render_template :index
     end

    it 'assigns all subjects to @subjects' do 
      subject
      second_subject = create(:second_subject)
      get :index
      expect(assigns(:subjects)).to eq([subject, second_subject])
    end
  end

  describe 'GET #new' do 
    
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new 
    end

    it 'assigns a new subject to @subject' do
      get :new
      expect(assigns(:subject)).to be_a_new(Subject)
    end
  end

  describe 'POST #create' do 

    context 'with valid attributes' do 
      
      it 'creates a new subject and redirects to the subjects index' do
        expect { 
          post :create, subject: subject_attributes
        }.to change(Subject, :count).by(1)
        expect(response).to redirect_to(subjects_path)
      end
    end

    context 'with invalid attributes' do 
    
      it 'does not create a new subject and renders the :new template' do
        expect {
          post :create, subject: invalid_subject_attributes
        }.not_to change(Subject, :count)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do 
    
    it 'renders the :show template' do 
      get :show, id: subject
      expect(response).to render_template :show
    end

    it 'sets the correct subject to @subject' do 
      get :show, id: subject
      expect(assigns(:subject)).to eq subject
    end
  end

  describe 'GET #edit' do 
    
    it 'renders the :edit template' do 
      get :edit, id: subject
      expect(response).to render_template :edit
    end

    it 'sets the correct subject to @subject' do 
      get :edit, id: subject
      expect(assigns(:subject)).to eq subject
    end
  end

  describe 'PUT #update' do 

    it 'sets the correct subject to @subject' do 
      put :update, id: subject, subject: subject_attributes
      expect(assigns(:subject)).to eq subject
    end

    context 'with valid attributes' do 
      
      it 'updates the subject and redirects to the subjects index' do
        put :update, id: subject, subject: {
          name: 'Test Subject'
        }
        subject.reload
        expect(subject.name).to eq 'Test Subject'
        expect(response).to redirect_to subjects_path
      end
    end

    context 'with invalid attributes' do 

      it 'does not update the subject and renders the :edit page' do 
       put :update, id: subject, subject: {
          name: nil
        }
        subject.reload
        expect(subject.name).not_to eq nil
      end
    end
  end

  describe 'DELETE #destroy' do

    it 'deletes the contact and redirects to the subjects index' do
      subject 
      expect {
        delete :destroy, id: subject
      }.to change(Subject, :count).by(-1)
      expect(response).to redirect_to subjects_path
    end
  end
end