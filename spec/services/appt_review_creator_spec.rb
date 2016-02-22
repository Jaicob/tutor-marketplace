require 'rails_helper'

RSpec.describe ApptReviewCreator do
  let(:completed_appt_no_review) {create(:appointment, :completed_without_review)}
  let(:completed_appt_with_review) {create(:appointment, :completed_with_review)}


  describe '#reviews_needed?' do 
    context 'when a student has 1+ completed appts with no review' do 
      it 'returns true' do 
        student = completed_appt_no_review.student
        expect(ApptReviewCreator.new(student).reviews_needed?).to eq true
      end
    end

    context 'when a student has 0 completed appts with no review' do 
      it 'returns false' do 
        student = completed_appt_with_review.student
        expect(ApptReviewCreator.new(student).reviews_needed?).to eq false
      end
    end
  end
  
  # describe '#create_reviews' do 
  #   context 'given no rating and no comment' do 
  #     it 'does not create a review' do 
  #       expect(Review.count).to eq 0
  #       params = {
  #         appt_reviews: {
  #           review_for_appt_1: {
  #             rating: nil, 
  #             comments: nil
  #           }
  #         }
  #       }
  #       ApptReviewCreator.new(@student, params).create_reviews
  #       expect(Review.count).to eq 0
  #     end
  #   end

  #   context 'given rating and no comment' do 
  #     it 'creates a review' do 
  #       expect(Review.count).to eq 0
  #       params = {
  #         appt_reviews: {
  #           review_for_appt_1: {
  #             rating: 'Positive', 
  #             comments: nil
  #           }
  #         }
  #       }
  #       ApptReviewCreator.new(@student, params).create_reviews
  #       expect(Review.count).to eq 0
  #     end

  #     it 'attaches appointment id to review' do 
  #       appt_id = completed_appt_no_review.id
  #       params = {
  #         appt_reviews: {
  #           review_for_appt_1: {
  #             rating: 'Positive', 
  #             comments: nil
  #           }
  #         }
  #       }
  #       ApptReviewCreator.new(@student, params).create_reviews
  #       expect(Review.last.appointment_id).to eq appt_id
  #     end
  #   end
    
  #   context 'given rating and comment' do 
  #     it 'creates a review' do 
  #       expect(Review.count).to eq 0
  #       params = {
  #         appt_reviews: {
  #           review_for_appt_1: {
  #             rating: 'Positive', 
  #             comments: 'Test comment'
  #           }
  #         }
  #       }
  #       ApptReviewCreator.new(@student, params).create_reviews
  #       expect(Review.count).to eq 0
  #     end

  #     it 'attaches appointment id to review' do
  #       appt_id = completed_appt_no_review.id
  #       params = {
  #         appt_reviews: {
  #           review_for_appt_1: {
  #             rating: 'Positive', 
  #             comments: 'Test comment'
  #           }
  #         }
  #       }
  #       ApptReviewCreator.new(@student, params).create_reviews
  #       expect(Review.last.appointment_id).to eq appt_id
  #     end
  #   end
  end
end