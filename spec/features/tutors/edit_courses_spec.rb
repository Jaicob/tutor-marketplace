require 'rails_helper'

feature 'A tutor can edit the courses they offer' do 
  given(:tutor) { create(:tutor) }

  scenario 'a tutor can access their edit courses page' do
    visit "/tutors/#{tutor.id}/courses"
    expect(page).to have_content 'Your Courses'
  end


end
