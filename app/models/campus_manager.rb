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

  validates :school_id, :user_id, presence: true

  delegate :first_name, :last_name, :full_name, :email, to: :user

  after_create :change_user_role_to_campus_manager

  def change_user_role_to_campus_manager
    self.user.update(role: 'campus_manager')
  end

end