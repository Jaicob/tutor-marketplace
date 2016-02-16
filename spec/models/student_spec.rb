# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  school_id        :integer
#  phone_number     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_id      :string
#  last_4_digits    :string
#  card_brand       :string
#  student_group_id :integer
#

require 'rails_helper'

RSpec.describe Student, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
