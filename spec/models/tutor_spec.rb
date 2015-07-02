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

  describe Tutor do
    let(:tutor) { build_stubbed(:tutor) }
    let(:complete_tutor) { create(:complete_tutor)}
    let(:incomplete_tutor) { build_stubbed(:incomplete_tutor) }

    it "is valid with extra info, an attached transcript, and first tutor_course" do 
      expect(tutor).to be_valid
    end

    it "is invalid without extra info" do 
      expect(build(:tutor, extra_info: nil)).to_not be_valid
    end

    it "has an 'applied' status until all Tutor fields are complete" do
      expect(tutor.application_status).to eq 'Applied'
    end

    it "has a complete status when all Tutor fields are complete" do
      expect(complete_tutor.application_status).to eq 'Awaiting Approval'
    end
  end
end