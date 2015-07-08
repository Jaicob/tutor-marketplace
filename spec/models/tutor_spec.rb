# == Schema Information
#
# Table name: tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  rating             :integer
#  application_status :integer          default(0)
#  birthdate          :date
#  degree             :string
#  major              :string
#  extra_info         :string
#  graduation_year    :string
#  phone_number       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  profile_pic        :string
#  transcript         :string
#  active_status      :integer          default(0)
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do

# Notes from Everyday Rails 

# A basic model spec should include tests for the following:
  # -The model's create method, when passed valid attributes, should be valid.
  # -Data that fail validations should not be valid.
  # -Class and instance methods perform as expected.

# Example model spec
  # decribe Contact do 
  #   it "is valid with a firstname, lastname and email"
  #   it "is invalid without a firstname"
  #   it "is invalid without a lastname"
  #   it "is invalid without an email address"
  #   it "is invalid with a duplicate email address"
  #   it "returns a contact's full name as a string"
  # end

# Best Practices
  # -A spec describes a set of expectations
  # -Each example (a line beginning with it) only expects one thing
  # -Each example is explicit (it has a description after it keyword)
  # -Each example's description begins with a verb, not should

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
      course = create(:course)
      second_course = create(:second_course)
      tutor.tutor_courses.create(course: course, rate: 30)
      tutor.tutor_courses.create(course: second_course, rate: 30)
      expect(tutor.schools).to eq ['University of North Carolina', 'University of Georgia']
    end

    it "shows User's name with .name" do 
      expect(complete_tutor.name).to eq complete_tutor.user.full_name
    end

    it "shows User's email with .email" do 
      expect(complete_tutor.email).to eq complete_tutor.user.email
    end

    it "shows tutor's sign_up_date with .sign_up_date" do 
      expect(tutor.sign_up_date).to eq Date.today
    end

end

