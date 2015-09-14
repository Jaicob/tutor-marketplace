# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  active_status      :integer          default(0)
#  application_status :integer          default(0)
#  rating             :integer
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  birthdate          :date
#  profile_pic        :string
#  transcript         :string
#  appt_notes         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line1              :string
#  line2              :string
#  city               :string
#  state              :string
#  postal_code        :string
#  ssn_last_4         :string
#  acct_id            :string
#  last_4_acct        :string
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do

    let(:tutor) { create(:tutor) }

    it "is valid with extra info, an attached transcript, and first tutor_course" do
      expect(tutor).to be_valid
    end

    it "is invalid without extra info" do
      expect(build(:tutor, extra_info: nil)).to_not be_valid
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

    it "can list its schools with .schools" do
      create_list(:tutor_course, 2, tutor: tutor)
      expect(tutor.schools.length).to eq(2)
    end

    it "shows User's name with .name" do
      expect(complete_tutor.full_name).to eq complete_tutor.user.full_name
    end

    it "shows User's email with .email" do
      expect(complete_tutor.email).to eq complete_tutor.user.email
    end

    it "shows tutor's sign_up_date with .sign_up_date" do
      expect(tutor.sign_up_date).to eq Date.today
    end

end

