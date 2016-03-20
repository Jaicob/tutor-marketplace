# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :integer
#

require 'rails_helper'

RSpec.describe Cart, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
