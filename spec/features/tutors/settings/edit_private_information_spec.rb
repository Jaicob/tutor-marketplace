require "rails_helper"

feature "Edit Private Information" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/private_information"
  end

  scenario "a tutor can edit their birthdate" do 
    fill_in 'tutor_birthdate', with: '2222-02-22'
    click_button 'Save'
    expect(page).to have_field 'tutor_birthdate', with: '2222-02-22'
  end

  scenario "a tutor can edit their phone number" do
    fill_in 'tutor_phone_number', with: '1234567890'
    click_button 'Save'
    expect(page).to have_field 'tutor_phone_number', with: '1234567890'
  end

end