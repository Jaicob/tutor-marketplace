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
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do

    let(:tutor) { create(:tutor) }
    let(:tutor_with_complete_application) { create(:tutor, :application_complete)}

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
      expect(tutor_with_complete_application.application_status).to eq 'Complete'
    end

    it "active status is 'Inactive' by default" do 
      expect(tutor.active_status).to eq 'Inactive'
    end

    it "active status can be changed to 'Active'" do 
      tutor.active_status=1
      expect(tutor.active_status).to eq 'Active'
    end

    it "shows User's name with .name" do 
      expect(tutor.full_name).to eq tutor.user.full_name
    end

    it "shows User's email with .email" do 
      expect(tutor.email).to eq tutor.user.email
    end

    it "shows tutor's sign_up_date with .sign_up_date" do 
      expect(tutor.sign_up_date).to eq Date.today
    end

end

