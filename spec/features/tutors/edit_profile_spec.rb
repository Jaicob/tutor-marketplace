require "rails_helper"

feature "A tutor can edit their profile" do
  let(:user)  { create(:user) }
  let(:tutor) { create(:complete_tutor) }

  before :each do
    @tutor = tutor
    sign_in(@tutor.user.email, @tutor.user.password)
  end

  scenario "a tutor can access the edit profile page" do
    visit "/#{tutor.user.slug}/dashboard/profile"
    click_link 'Edit'
    expect(page).to have_css '#finish_edit_profile_button'
  end

  scenario 'a tutor can edit their degree' do 
    visit "/#{tutor.user.slug}/dashboard/profile"
    expect(page).to have_content 'Degree: B.A.'
    click_link 'Edit'
    fill_in 'tutor_degree', with: 'Bachelors'
    click_button 'Save Changes'
    expect(page).to have_content 'Degree: Bachelors'
  end

  scenario 'a tutor can edit their major' do 
    visit "/#{tutor.user.slug}/dashboard/profile"
    expect(page).to have_content 'Major: Biology'
    click_link 'Edit'
    fill_in 'tutor_major', with: 'Computer Science'
    click_button 'Save Changes'
    expect(page).to have_content 'Major: Computer Science'
  end

  scenario 'a tutor can edit their extra_info' do 
    visit "/#{tutor.user.slug}/dashboard/profile"
    expect(page).to have_content 'Extra Info: Student Research Assistant for Biology Department'
    click_link 'Edit'
    fill_in 'tutor_extra_info', with: 'I can tutor you'
    click_button 'Save Changes'
    expect(page).to have_content 'Extra Info: I can tutor you'
  end
  
  scenario 'a tutor can edit their graduation_year' do
    visit "/#{tutor.user.slug}/dashboard/profile"
    expect(page).to have_content 'Graduation Year: 2019'
    click_link 'Edit'
    fill_in 'tutor_graduation_year', with: '2025'
    click_button 'Save Changes'
    expect(page).to have_content 'Graduation Year: 2025'
  end


end