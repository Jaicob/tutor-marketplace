require "rails_helper"

feature "Edit Account Settings" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/account_settings"
  end

  scenario "a tutor can edit their first name" do
    fill_in 'user_first_name', with: 'Test First Name'
    click_button 'Save'
    expect(page).to have_field 'user_first_name', with: 'Test First Name'
  end

  scenario "a tutor can edit their last name" do
    fill_in 'user_last_name', with: 'Test Last Name'
    click_button 'Save'
    expect(page).to have_field 'user_last_name', with: 'Test Last Name'
  end

  scenario "a tutor can edit their email" do 
    fill_in 'user_email', with: 'test@example.com'
    click_button 'Save'
    expect(page).to have_field 'user_email', with: 'test@example.com'
  end

end