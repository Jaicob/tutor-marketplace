# == Schema Information
#
# Table name: tutors
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  rating                  :integer
#  status                  :integer          default(0)
#  birthdate               :date
#  degree                  :string
#  major                   :string
#  extra_info              :string
#  graduation_year         :string
#  phone_number            :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  transcript_file_name    :string
#  transcript_content_type :string
#  transcript_file_size    :integer
#  transcript_updated_at   :datetime
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
    let(:tutor) { FactoryGirl.build_stubbed(:tutor) }
    let(:incomplete_tutor) { FactoryGirl.build_stubbed(:incomplete_tutor) }

    it "is valid with extra info, an attached transcript, and first tutor_course" do 
      expect(tutor).to be_valid
    end

    it "is invalid without extra info" do 
      expect(build(:tutor, extra_info: nil)).to_not be_valid
    end

    it "is invalid without an attached transcript" do 
      expect(build(:tutor, transcript_file_name: nil)).to_not be_valid
    end

    it "has an incomplete status until all Tutor fields are complete" do
      expect(tutor.status).to eq 'applied'
    end

    it "has a first tutor_course set on creation" do 
      skip 'need to figure out how to do this without triggering infinite loop between factories'
    end

    it "has a complete status when all Tutor fields are complete" do 
    end

    it "has first course set by set_first_tutor_course method" do 
    end

  end

end
