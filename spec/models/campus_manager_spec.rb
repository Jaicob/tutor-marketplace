# == Schema Information
#
# Table name: campus_managers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  school_id    :integer
#  profile_pic  :string
#  phone_number :string
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe CampusManager, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
