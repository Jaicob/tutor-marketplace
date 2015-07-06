require 'rails_helper'

feature "Admin can manage tutors' Active Statuses" do 
  let(:admin) { create(:user, :admin) }
  let(:tutor) { create(:complete_tutor) }

  before :each do 
    sign_in(admin.email, admin.password)
    tutor
  end

  scenario "Admin can view a tutor's active status", :js => true do
  end

end
