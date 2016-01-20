# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  issuer           :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer          default(0)
#  description      :text
#  tutor_id         :integer
#  course_id        :integer
#  single_use       :integer          default(0)
#

require 'rails_helper'

RSpec.describe Promotion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
