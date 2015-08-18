require 'rails_helper'

feature "Admin can only access the appropriate schools based on role" do 
  let(:super_admin) { create(:user, :super_admin) }
  let(:campus_manager) { create(:user, :campus_manager) }

  before :each do 
    create_list(:course, 3)
  end

  scenario "Super-Admin views records for all schools" do
    sign_in(super_admin.email, super_admin.password)
    visit '/admin/courses'
    expect(page).to have_content ('University 1')
    expect(page).to have_content ('University 2')
    expect(page).to have_content ('University 3')
    expect(page).not_to have_content ("Campus Manager's University")
  end

  scenario "Campus-Manager views record for only their one school" do
    sign_in(campus_manager.email, campus_manager.password)
    visit '/admin/courses'
    expect(page).to have_content ("Campus Manager's University")
    expect(page).not_to have_content ('University 1')
    expect(page).not_to have_content ('University 2')
    expect(page).not_to have_content ('University 3')
  end
end
