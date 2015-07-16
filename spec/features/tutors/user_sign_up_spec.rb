require 'rails_helper'

feature 'Tutor sign up for registered users' do 
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  before :each do 
    sign_in(user.email, user.password)
    course
  end

  scenario 'user can create a tutor account' do 
    visit '/tutors/new'
    select('University 1', from: 'course[school_id]')
    select "CHEM", from: 'course[subject_id]'
    select '101 | Intro to Chemistry', from: 'course[course_id]'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page.body).to have_content "Dashboard"
  end

  scenario 'user cannot create a tutor account without uploading a transcript' do 
    visit '/tutors/new'
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_selector ".alert", text: "Tutor account was not created. Please fill in all fields and attach your unofficial transcript"
  end

end