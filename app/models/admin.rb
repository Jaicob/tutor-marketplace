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
