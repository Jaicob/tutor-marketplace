require "rails_helper"

feature "A tutor can edit their profile" do

  let(:user)  { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  before :each do
    sign_in(user.email, user.password)
  end

  scenario "a tutor can access the edit profile page" do
    visit "/#{tutor.user.slug}/dashboard/profile"
    click_button "Edit"
    expect(page.body).to have_selector "#tutor_degree"
    expect(page.body).to have_selector "#tutor_major"
    expect(page.body).to have_selector "#tutor_extra_info"
    expect(page.body).to have_selector "#tutor_graduation_year"
  end

  scenario "a tutor can change their qualifications on the edit page" do
    visit "/#{tutor.user.slug}/dashboard/profile"
    click_button "Edit"
    fill_in '#tutor_degree', with: 'Bachelors'
    fill_in '#tutor_major', with: 'Computer Science'
    fill_in '#tutor_extra_info', with: 'I can tutor you'
    fill_in '#tutor_graduation_year', with: '2025'
    click_button "Save Changes"
    visit "/#{tutor.slug}/dashboard/profile"
    expect(page.body).to have_content "Degree: Bachelors"
    expect(page.body).to have_content "Major: Computer Science"
    expect(page.body).to have_content "Extra Info: I can tutor you"
    expect(page.body).to have_content "Graduation Year: 2025"
  end

end