# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin < ActiveRecord::Base
  belongs_to :user

  after_create :change_user_role_to_admin

  def change_user_role_to_admin
    self.user.update(role: 'admin')
    if self.user.tutor
      self.user.tutor.destroy
    end
    if self.user.student
      self.user.student.destroy
    end
    if self.user.campus_manager
      self.user.campus_manager.destroy
    end
  end

end
