require "rails_helper"

feature "A tutor can edit their settings" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/account_settings"
  end

  scenario "a tutor can edit their first name (on user account)" do
    expect(page).to have_selector("input[value='Bob']")
    fill_in 'user_first_name', with: 'AJ'
    click_button 'Update Account Settings'
    expect(page).to have_selector("input[value='AJ']")
  end

  scenario "a tutor can edit their last name (on user account)" do
    expect(page).to have_selector("input[value='Dole']") 
    fill_in 'user_last_name', with: 'Banerjee'
    click_button 'Update Account Settings'
    expect(page).to have_selector("input[value='Banerjee']")
  end

  scenario "a tutor can edit their email (on user account)" do 
    expect(page).not_to have_selector("input[value='aj@axontutors.com']")
    fill_in 'user_email', with: 'aj@axontutors.com'
    click_button 'Update Account Settings'
    expect(page).to have_selector("input[value='aj@axontutors.com']")
  end

  scenario "a tutor can edit their birthdate" do 
    expect(page).to have_selector("input[value='1992-05-28']")
    fill_in 'tutor_birthdate'   , with: '2000-01-30'
    click_button 'Update Tutor Settings'
    expect(page).to have_selector("input[value='2000-01-30']")
  end

  scenario "a tutor can edit their phone number" do
    expect(page).to have_selector("input[value='555-555-5555']")
    fill_in 'tutor_phone_number', with: '1234567890'
    click_button 'Update Tutor Settings'
    expect(page).to have_selector("input[value='1234567890']")
  end

end