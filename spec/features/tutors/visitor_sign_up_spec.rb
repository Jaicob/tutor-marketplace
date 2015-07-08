require 'rails_helper'

feature 'Tutor sign up for visitors' do 
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  before :each do 
    course
  end

  scenario 'visitor is prompted to register or login after creating a tutor acount' do
    visit '/tutors/visitor_new'
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Login or create a new account now" 
  end

  scenario 'visitor can sign up as tutor then create an account' do
    visit 'tutors/visitor_new'
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Login or create a new account now"
    click_link 'Sign Up'
    fill_in 'user_first_name', with: user.first_name
    fill_in 'user_last_name', with: user.last_name
    fill_in 'user_email', with: 'another-email@example.com'
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'non-signed in user (accidental visitor) can sign up as tutor then log in succesfully' do
    user
    visit 'tutors/visitor_new'
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    attach_file('tutor_transcript', 'app/assets/images/doge.png')
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Login or create a new account now"
    # Can't use sign_in(user) method because this sign-in is at a different URL than '/users/sign_in'
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page.body).to have_content 'Dashboard'
  end



end