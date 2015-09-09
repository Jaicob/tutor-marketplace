require "rails_helper"

feature "Edit Profile Settings" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/profile_settings"
  end

  scenario "a tutor can access the edit profile fields settings page from their preview profile" do
    visit "/#{tutor.user.slug}/dashboard/profile"
    click_link 'Edit'
    expect(page).to have_content ('Public Profile Fields')
  end

  scenario 'a tutor can edit their degree' do 
    fill_in 'tutor_degree', with: 'Test Degree'
    click_button 'Save'
    expect(page).to have_field('tutor_degree', with: 'Test Degree')
  end

  scenario 'a tutor can edit their major' do 
    fill_in 'tutor_major', with: 'Test Major'
    click_button 'Save'
    expect(page).to have_field('tutor_major', with: 'Test Major')
  end

  scenario 'a tutor can edit their extra_info' do 
    fill_in 'tutor_extra_info', with: 'Test Extra Info'
    click_button 'Save'
    expect(page).to have_field('tutor_extra_info', with: 'Test Extra Info')
  end
  
  scenario 'a tutor can edit their graduation_year' do
    fill_in 'tutor_graduation_year', with: 'Test Year'
    click_button 'Save'
    expect(page).to have_field('tutor_graduation_year', with: 'Test Year')
  end

end