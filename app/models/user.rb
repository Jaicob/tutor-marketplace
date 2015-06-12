# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  role                   :integer
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  first_name             :text
#  last_name              :string
#  slug                   :string
#

class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_one :tutor, dependent: :destroy
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  # This method is for when a Tutor profile has been created without a User (by a visitor or non-signed in user) and the Tutor needs to be assigned to the User after log-in or sign-up
  def set_tutor_for_devise(user, params)
    unless params[:tutor_id] == nil
      user.tutor=Tutor.find(params[:tutor_id])
    end
  end

 def slug_candidates
    # These are simply various combinations of first and last names to create usernames in case of multiple users with the same name, the next available unique combo is used to create the slug
    [ "#{first_name} #{last_name}", "#{first_name[0]} #{last_name}", "#{first_name} #{last_name[0]}", "#{first_name[0..1]} #{last_name}", "#{first_name} #{last_name[0..1]}", "#{first_name[0..2]} #{last_name}", "#{first_name} #{last_name[0..2]}", "#{first_name[0..3]} #{last_name}", "#{first_name} #{last_name[0..3]}",
    ]
  end

  def full_name
    "#{first_name} #{last_name}"
  end


end
