require "rails_helper"

feature "Edit Tutor Payment Settings" do
  let(:tutor) { create(:tutor) }

  before :each do
    sign_in(tutor.user.email, tutor.user.password)
    visit "/#{tutor.user.slug}/dashboard/settings/tutor_payment_settings"
  end


  scenario "a tutor can edit their payment info" do
  end

end