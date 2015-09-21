# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  type             :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Promotion < ActiveRecord::Base
end
