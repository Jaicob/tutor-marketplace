require 'rails_helper'

feature "Admin can use course_list mass creation functionality" do 
  let(:super_admin) { create(:user, :super_admin) }
  let(:campus_manager) { create(:user, :campus_manager) }

  before :each do 
    create_list(:course, 3)
  end

  scenario "Super-Admin can create a new course_list" do
    sign_in(super_admin.email, super_admin.password)
    visit '/admin/courses/new'
    within_fieldset('Enter a Course List') do
      select("University 1", from: 'School')
      select('Biology', from: 'course_list_setup_name')
      fill_in('# of Courses to Add', with: '3')
    end
    click_button('Start List')
    within(:css, "div.row.course-1-row") do
      fill_in('Call number', with: '101')
      fill_in('Friendly name', with: 'Class A')
    end
    within(:css, "div.row.course-2-row") do
      fill_in('Call number', with: '201')
      fill_in('Friendly name', with: 'Class B')
    end
    within(:css, "div.row.course-3-row") do
      fill_in('Call number', with: '301')
      fill_in('Friendly name', with: 'Class C')
    end
    click_button('Review Course List')
    expect(page).to have_content 'Review course list for:'
    click_button('Create Courses')
    expect(page).to have_content 'Course list was succesfully created'
  end

  scenario "Campus-Manager can create a new course_list" do
    sign_in(campus_manager.email, campus_manager.password)
    visit '/admin/courses/new'
    within_fieldset('Enter a Course List') do
      select("Campus Manager's University", from: 'School')
      select('Biology', from: 'course_list_setup_name')
      fill_in('# of Courses to Add', with: '3')
    end
    click_button('Start List')
    within(:css, "div.row.course-1-row") do
      fill_in('Call number', with: '101')
      fill_in('Friendly name', with: 'Class A')
    end
    within(:css, "div.row.course-2-row") do
      fill_in('Call number', with: '201')
      fill_in('Friendly name', with: 'Class B')
    end
    within(:css, "div.row.course-3-row") do
      fill_in('Call number', with: '301')
      fill_in('Friendly name', with: 'Class C')
    end
    click_button('Review Course List')
    expect(page).to have_content 'Review course list for:'
    click_button('Create Courses')
    expect(page).to have_content 'Course list was succesfully created'
  end






end
