# == Schema Information
#
# Table name: student_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer
#  school_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe StudentGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
