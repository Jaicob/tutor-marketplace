require 'rails_helper'

feature 'tutor account creation' do 
  given(:user) { create(:user) }
  given!(:school) { create(:school) }

  scenario 'user accesses tutor sign_up form from home page' do
    sign_in user
    visit '/'
    click_on 'Start Tutoring'
    visit '/tutors/new'
    expect(page).to have_content 'Register to become an Axon tutor'
  end

  scenario 'visitor accesses tutor sign_up form from home page' do 
    visit '/'
    click_on "Start Tutoring"
    expect(page).to have_content 'Register to become an Axon tutor'
  end

  scenario 'user creates a tutor account with one class' do 
    visit '/tutors/new'
    school
    puts page.body
    select 'University of North Carolina', from: 'tutor_school'
    select 'CHEM', from: 'tutor_subject'
    select '211', from: 'Course'
    fill_in 'Rate', with: '35'
    fill_in 'Bio', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "Welcome to your Dashboard!"  
  end

  scenario 'tutor uploads unofficial transcript' do 
  end


end