require 'rails_helper'

feature 'Tutor sign up for registered users' do 
  given(:user) { create(:user) }
  given(:school) { create(:school) }
  given(:course) { create(:course) }

  scenario 'user can create a tutor account' do 
    sign_in(user)
    visit '/tutors/new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page.body).to have_content "Dashboard"
  end

  scenario 'user cannot create a tutor account without uploading a transcript' do 
    user
    sign_in(user)
    visit '/tutors/new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Tutor account was not created. Please fill in all fields and attach your unofficial transcript"  
  end

  scenario 'user cannot create a tutor account without adding a class' do
    user
    sign_in(user)
    visit '/tutors/new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    fill_in 'Rate', with: '35'
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Tutor account was not created. Please fill in all fields and attach your unofficial transcript"
  end


end