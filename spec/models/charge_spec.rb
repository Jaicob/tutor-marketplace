# == Schema Information
#
# Table name: charges
#
#  id           :integer          not null, primary key
#  amount       :integer
#  axon_fee     :integer
#  tutor_fee    :integer
#  customer_id  :string
#  tutor_id     :integer
#  token        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  promotion_id :integer
#

require 'rails_helper'

RSpec.describe Charge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
