# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  appointment_id :integer          not null
#  rating         :integer
#  comment        :text
#  follow_up      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Review, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
