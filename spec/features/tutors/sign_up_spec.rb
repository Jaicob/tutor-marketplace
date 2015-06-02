require 'rails_helper'

feature 'tutor account creation' do 
  given(:user) { create(:user) }
  given!(:school) { create(:school) }
  given!(:course) { create(:course) }

  scenario 'user accesses tutor sign_up form from home page' do
    sign_in user
    visit '/'
    click_on 'Start Tutoring'
    expect(page).to have_content 'Start tutoring with Axon'
  end

  scenario 'visitor accesses tutor sign_up form from home page' do 
    visit '/'
    click_on "Start Tutoring"
    expect(page).to have_content 'Start tutoring with Axon'
  end

  scenario 'user creates a tutor account with one class' do 
    visit '/tutor_courses/new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    select '101 | Intro to Chemistry', from: 'course_course_id'
    fill_in 'Rate', with: '35'
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).to have_content "This is the home page"  
  end

  scenario 'user cannot create a tutor account without adding a class' do
    visit '/tutor_courses/new'
    school
    course
    select 'University of North Carolina', from: 'course_school_id'
    select "CHEM", from: 'course_subject_id'
    fill_in 'Rate', with: '35'
    fill_in 'tutor_extra_info', with: 'I love chemistry so freaking much...'
    click_button 'Next'
    expect(page).not_to have_content "This is the home page"
  end


  scenario 'tutor uploads unofficial transcript' do 
  end


end