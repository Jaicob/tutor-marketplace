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

class CampusManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
end
