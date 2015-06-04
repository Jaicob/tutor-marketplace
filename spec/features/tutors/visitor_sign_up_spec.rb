require 'rails_helper'

feature 'Tutor sign up for visitors' do 
  given(:user) { create(:user) }
  given!(:school) { create(:school) }
  given!(:course) { create(:course) }

  scenario 'visitor is prompted to register or login after creating a tutor acount' do
    visit '/tutors/visitor_new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Login or create a new account now" 
  end

  scenario 'non-signed in user can sign up as tutor then log in succesfully' do
    user
    visit 'tutors/visitor_new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Login or create a new account now" 
    click_button 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end




end
