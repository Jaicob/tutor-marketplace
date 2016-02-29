# require 'rails_helper'

# RSpec.describe BookingPreview do
#   let(:completed_appt_no_review) {create(:appointment, :completed_without_review)}
#   let(:completed_appt_with_review) {create(:appointment, :completed_with_review)}


#   describe '#reviews_needed?' do 
#     context 'when a student has 1+ completed appts with no review' do 
#       it 'returns true' do 
#         student = completed_appt_no_review.student
#         expect(ApptReviewCreator.new(student).reviews_needed?).to eq true
#       end
#     end

#     context 'when a student has 0 completed appts with no review' do 
#       it 'returns false' do 
#         student = completed_appt_with_review.student
#         expect(ApptReviewCreator.new(student).reviews_needed?).to eq false
#       end
#     end
#   end
# end