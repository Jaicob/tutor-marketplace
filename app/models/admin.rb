class Admin < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  after_create :change_user_role_to_admin

  def change_user_role_to_admin
    self.user.update(role: 'admin')
  end

end
