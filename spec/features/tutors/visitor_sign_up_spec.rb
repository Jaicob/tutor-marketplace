require 'rails_helper'

feature 'Tutor sign up for visitors' do 
  given(:user) { create(:user) }
  given(:user_stub) { build_stubbed(:user) }
  given!(:school) { create(:school) }
  given!(:course) { create(:course) }

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
    fill_in 'user_first_name', with: user_stub.first_name
    fill_in 'user_last_name', with: user_stub.last_name
    fill_in 'user_email', with: user_stub.email
    fill_in 'user_password', with: user_stub.password
    fill_in 'user_password_confirmation', with: user_stub.password
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
    expect(page).to have_content 'Signed in successfully'
  end



end
