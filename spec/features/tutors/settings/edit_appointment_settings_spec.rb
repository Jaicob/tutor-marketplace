require "rails_helper"

feature "Edit Appointment Settings" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/appointment_settings"
  end

  scenario "a tutor can edit their personal note to students" do
    fill_in 'tutor_appt_notes', with: 'This is a test note'
    click_button 'Save'
    expect(page).to have_field 'tutor_appt_notes', with: 'This is a test note'
  end

end