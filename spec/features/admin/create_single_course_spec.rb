require 'rails_helper'

feature "Admin can create a single course" do 
  let(:admin) { create(:user, :super_admin) }
  let(:school) { create(:school) }
  let(:subject) { create(:subject) }

  before :each do 
    sign_in(admin.email, admin.password)
    @school = school
    @subject = subject
  end

  scenario "An admin user can create a new course" do
    visit '/admin/courses/new'
    expect(page).to have_content 'New Course'
    within_fieldset('Add a Single Course') do 
      select(@school.name, from: 'School')
      select(@subject.name, from: 'Subject')
      fill_in('Call number', with: 101)
      fill_in('Friendly name', with: 'Intro to Testing')
    end
    puts page.body
    click_button("Create Course")
    puts "AFTER"
    puts page.body
    expect(page).to have_content 'Course Details'
  end
end
