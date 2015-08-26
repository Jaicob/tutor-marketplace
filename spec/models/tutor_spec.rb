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
#  appt_notes         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do

    let(:tutor) { create(:tutor) }
    let(:complete_tutor) { create(:complete_tutor)}
    let(:incomplete_tutor) { build_stubbed(:incomplete_tutor) }

    it "is valid with extra info, an attached transcript, and first tutor_course" do 
      expect(tutor).to be_valid
    end

    it "is invalid without extra info" do 
      expect(build(:tutor, extra_info: nil)).to_not be_valid
    end

    # This validation has been removed, may add back later
    # it "is invalid without an attached transcript" do 
    #   expect(build(:tutor, transcript: nil)).to_not be_valid
    # end

    it "application status is 'Applied' by default" do
      expect(tutor.application_status).to eq 'Applied'
    end

    it "application status is 'Awaiting Appproval' when all Tutor fields are complete" do
      expect(complete_tutor.application_status).to eq 'Awaiting Approval'
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

