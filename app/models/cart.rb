# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cart < ActiveRecord::Base
  serialize :info # temporarily stores course_id, tutor_id, appt_times and location_preference as hash in CheckoutController
end
