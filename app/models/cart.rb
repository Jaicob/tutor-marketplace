# == Schema Information
#
# Table name: carts
#
#  id            :integer          not null, primary key
#  checkout_hash :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Cart < ActiveRecord::Base
  serialize :checkout_hash
end
