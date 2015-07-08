# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  call_number   :integer
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  school_id     :integer
#  subject       :integer
#

require 'rails_helper'

RSpec.describe Course, type: :model do
end
