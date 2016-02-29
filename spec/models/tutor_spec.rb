# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  school_id          :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  approval           :integer
#  degree             :integer          default(0)
#  major              :string
#  additional_degrees :string
#  extra_info_1       :text
#  extra_info_2       :text
#  extra_info_3       :text
#  graduation_year    :string
#  phone_number       :string
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  onboarding_status  :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  last_4_acct        :string
#  line1              :string
#  line2              :string
#  city               :string
#  state              :string
#  postal_code        :string
#  ssn_last_4         :string
#  acct_id            :string
#  slug               :string
#  dob                :date
#  booking_buffer     :integer          default(6)
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do

  let(:tutor) { create(:tutor) }
  let(:ready_to_book_tutor) { create(:tutor, :with_tutor_course_and_slot)}
  let(:appt_with_review) { create(:appointment, :completed_with_review)}
  let(:appt_without_review) { create(:appointment, :completed_without_review)}
  let(:tutor_with_appts) {create(:tutor, :with_two_appointments)}

  it "is valid with extra info, an attached transcript, and first tutor_course" do
    expect(tutor).to be_valid
  end

  it "application_status is 'Incomplete' by default" do
    expect(tutor.application_status).to eq 'Incomplete'
  end

  it "application_status is changed to 'Complete' when all required fields are complete" do
    skip 'cant test without extra gem to enable testing an after_commit hook. dont think its worth an extra dependency'
  end

  it "active status is 'Inactive' by default" do
    expect(tutor.active_status).to eq 'Inactive'
  end

  it "active status can be changed to 'Active'" do
    tutor.active_status=1
    expect(tutor.active_status).to eq 'Active'
  end

  it "shows User's full name with .full_name" do
    expect(tutor.full_name).to eq tutor.user.full_name
  end

  it "shows User's email with .email" do
    expect(tutor.email).to eq tutor.user.email
  end

  describe "#reviews" do

    it 'returns an array' do 
      expect(tutor.reviews.class).to eq Array
    end

    context 'when a tutor has no appointments' do 
      it 'returns an empty array' do
        expect(tutor.reviews.count).to eq 0
      end
    end

    context 'when a tutor has 1 appt, which has a review' do 
      it 'returns an array with 1 item' do 
        tutor = appt_with_review.tutor
        expect(tutor.appointments.count).to eq 1
        expect(tutor.reviews.count).to eq 1
      end
    end

    context 'when a tutor has 1 appt, which does not have a review' do 
      it 'returns an empty array' do 
        tutor = appt_without_review.tutor
        expect(tutor.appointments.count).to eq 1
        expect(tutor.reviews.count).to eq 0
      end
    end

    context 'when a tutor has 2 appts & 0 reviews' do 
      it 'returns an array with 0 items' do
        tutor = tutor_with_appts
        expect(tutor.appointments.count).to eq 2
        expect(tutor.reviews.count).to eq 0
      end
    end

    context 'when a tutor has 2 appts & 1 review' do 
      it 'returns an array with 1 item' do
        tutor = tutor_with_appts
        create(:review, appointment: tutor.appointments.first)
        expect(tutor.appointments.count).to eq 2
        expect(tutor.reviews.count).to eq 1
      end
    end

    context 'when a tutor has 2 appts & 2 reviews' do 
      it 'returns an array with 2 items' do
        tutor = tutor_with_appts
        create(:review, appointment: tutor.appointments.first)
        create(:review, appointment: tutor.appointments.second)
        expect(tutor.appointments.count).to eq 2
        expect(tutor.reviews.count).to eq 2
      end
    end
  end
end

