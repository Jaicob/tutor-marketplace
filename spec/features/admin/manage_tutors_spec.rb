require 'rails_helper'

feature 'an admin can change the active status of tutors' do 
  given(:tutor) { create(:tutor) }

  scenario 'an admin can activate a tutor' do 
    START HERE
  end
end



# require 'rails_helper'

# feature 'A tutor can edit the courses they offer' do 
#   given(:tutor) { create(:tutor) }

#   scenario 'a tutor can access their edit courses page'do
#     skip
#     visit "/tutors/#{tutor.id}/courses"
#     expect(page).to have_content 'Your Courses'
#   end


# end
