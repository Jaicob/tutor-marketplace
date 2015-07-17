require "rails_helper"

feature "A tutor can edit their settings" do
  let(:user)  { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings"
  end

  scenario "a tutor can edit user-specific settings" do
    expect(page.body).to have_selector "#user_first_name"
    expect(page.body).to have_selector "#user_last_name"
    expect(page.body).to have_selector "#user_email"
    expect(page.body).to have_selector "#user_slug"
    expect(page.body).to have_selector "input[name=\"commit\"]"
    within 'form.edit_user' do
      fill_in '#user_first_name', with: 'AJ'
      fill_in '#user_last_name' , with: 'Banerjee'
      fill_in '#user_email'     , with: 'aj@axontutors.com'
      fill_in '#user_slug'      , with: 'aj'
      find('input[name="commit"]').click
    end
    expect(page.body).to have_selector "#user_first_name[value=\"AJ\"]"
    expect(page.body).to have_selector "#user_last_name[value=\"Banerjee\"]"
    expect(page.body).to have_selector "#user_email[value=\"aj@axontutors.com\"]"
    expect(page.body).to have_selector "#user_slug[value=\"aj\"]"
  end

  scenario "a tutor can edit tutor-specific settings" do
    expect(page.body).to have_selector "#tutor_birthdate"
    expect(page.body).to have_selector "#tutor_phone_number"
    expect(page.body).to have_selector "#tutor_active_status"
    expect(page.body).to have_selector "input[name=\"commit\"]"
    within 'form.edit_tutor' do
      fill_in("#tutor_birthdate")  , with: '2000-01-30'
      fill_in '#tutor_phone_number', with: '1234567890'
      find("#tutor_active_status option[value='Inactive']").click
      find('input[name="commit"]').click
    end
    expect(page.body).to have_selector "#tutor_birthdate[value=\"2000-01-30\"]"
    expect(page.body).to have_selector "#user_last_name[value=\"Banerjee\"]"
    expect(page.body).to have_selector "#tutor_active_status option[value='Inactive']"
    expect(page.body).to have_selector "#user_slug[value=\"aj\"]"
  end
end