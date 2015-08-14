# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  transaction_percentage :float
#

require 'rails_helper'

RSpec.describe School, type: :model do

  it "is valid with a name and location" do
    expect(build(:school)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:school, name: nil)).not_to be_valid
  end

  it "is invalid with a duplicate name" do
    create(:school)
    expect(build(:school, name: nil)).not_to be_valid
  end

  it "is invalid without a location" do
    expect(build(:school, location: nil)).not_to be_valid
  end

  it "returns a list of its unique subjects with .subjects" do
    school = create(:school_with_two_subjects)
    expect(school.subjects.count).to eq(2)
  end
end
