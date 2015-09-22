require 'rails_helper'

describe TutorsController do
  let(:course) { create(:course) }
  let(:tutor) { create(:tutor_with_complete_application) }

  describe 'GET #show' do 
  
    it "assigns the correct tutor to @tutor" do
      get :show, id: tutor
      expect(assigns(:tutor)).to eq tutor
    end

    it "renders the :show template" do 
      get :show, id: tutor
      expect(response).to render_template :show
    end
  end

  describe 'PUT #update' do 

    it "assigns the correct tutor to @tutor" do
      login_with tutor.user
      expect(tutor.degree).to eq 'B.A.'
      patch :update, id: tutor, tutor: {degree: 'PhD.'}
      expect(assigns(:tutor)).to eq tutor
      expect(tutor.reload.degree).to eq 'PhD.'
    end

    it "updates a tutor's degree" do 
      login_with tutor.user
      expect(tutor.degree).to eq 'B.A.'
      patch :update, id: tutor, tutor: {degree: 'PhD.'}
      expect(tutor.reload.degree).to eq 'PhD.'
    end

    it "updates a tutor's major" do 
      login_with tutor.user
      expect(tutor.major).to eq 'Biology'
      patch :update, id: tutor, tutor: {major: 'Test Major'}
      expect(tutor.reload.major).to eq 'Test Major'
    end

    it "updates a tutor's graduation_year" do 
      login_with tutor.user
      expect(tutor.graduation_year).to eq '2019'
      patch :update, id: tutor, tutor: {graduation_year: '2030'}
      expect(tutor.reload.graduation_year).to eq '2030'
    end

    it "updates a tutor's extra_info" do 
      login_with tutor.user
      expect(tutor.extra_info).to eq 'Default Extra Info'
      patch :update, id: tutor, tutor: {extra_info: 'Test Info'}
      expect(tutor.reload.extra_info).to eq 'Test Info'
    end

    it "updates a tutor's phone_number" do 
      login_with tutor.user
      expect(tutor.phone_number).to eq '555-555-5555'
      patch :update, id: tutor, tutor: {phone_number: '444-444-4444'}
      expect(tutor.reload.phone_number).to eq '444-444-4444'
    end

    it "updates a tutor's birthdate" do 
      login_with tutor.user
      expect(tutor.birthdate).to eq 'Thu, 28 May 1992'.to_date
      patch :update, id: tutor, tutor: {birthdate: '2015-01-01'.to_date}
      expect(tutor.reload.birthdate).to eq 'Thu, 01 Jan 2015'.to_date
    end

    it "updates a tutor's appt_notes" do 
      login_with tutor.user
      expect(tutor.appt_notes).to eq 'Default Appt Notes'
      patch :update, id: tutor, tutor: {appt_notes: 'Test Note'}
      expect(tutor.reload.appt_notes).to eq 'Test Note'
    end

    it "updates a tutor's line1" do 
      login_with tutor.user
      expect(tutor.line1).to eq '101 Axon Way'
      patch :update, id: tutor, tutor: {line1: 'Test Line1'}
      expect(tutor.reload.line1).to eq 'Test Line1'
    end

    it "updates a tutor's line2" do 
      login_with tutor.user
      expect(tutor.line2).to eq 'Suite A'
      patch :update, id: tutor, tutor: {line2: 'Test Line2'}
      expect(tutor.reload.line2).to eq 'Test Line2'
    end

    it "updates a tutor's city" do 
      login_with tutor.user
      expect(tutor.city).to eq 'Athens'
      patch :update, id: tutor, tutor: {city: 'Test City'}
      expect(tutor.reload.city).to eq 'Test City'
    end

    it "updates a tutor's state" do 
      login_with tutor.user
      expect(tutor.state).to eq 'GA'
      patch :update, id: tutor, tutor: {state: 'Test State'}
      expect(tutor.reload.state).to eq 'Test State'
    end

    it "updates a tutor's postal_code" do 
      login_with tutor.user
      expect(tutor.postal_code).to eq '23123'
      patch :update, id: tutor, tutor: {postal_code: '55555'}
      expect(tutor.reload.postal_code).to eq '55555'
    end

    it "updates a tutor's ssn_last_4" do 
      login_with tutor.user
      expect(tutor.ssn_last_4).to eq '1211'
      patch :update, id: tutor, tutor: {ssn_last_4: '3333'}
      expect(tutor.reload.ssn_last_4).to eq '3333'
    end
  end

end