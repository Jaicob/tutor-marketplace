require 'rails_helper'

feature "Admin can manage tutors' Active Statuses" do 
  given(:admin) { create(:user, :admin) }
  given(:tutor) { create(:complete_tutor) }

  before :each do 
    sign_in(admin.email, admin.password)
    tutor
  end

  scenario "Admin can view a tutor's active status", :js => true do
    skip 'Need to figure out this test'
    visit "/#{admin.id}/dashboard/tutors"
    bip_select(Tutor, active_status, Active)
  end

end
