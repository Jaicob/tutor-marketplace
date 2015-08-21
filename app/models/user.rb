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
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  role                   :integer          default(0)
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  slug                   :string
#  school_id              :integer
#

class User < ActiveRecord::Base
  has_one :tutor, dependent: :destroy
  has_one :student, dependent: :destroy
  belongs_to :school

  enum role: [:user, :campus_manager, :super_admin]
  
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  devise :async, :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def create_tutor_account(user, params)
    if params[:user][:tutor] != nil
      user.create_tutor!(
        extra_info: params[:user][:tutor][:extra_info],
        phone_number: params[:user][:tutor][:extra_info]
        )
      user.tutor.tutor_courses.create(course_id: params[:course][:course_id], rate: params[:tutor_course][:rate])
    end
  end

  def slug_candidates
    [ 
      "#{first_name}#{last_name}", 
      "#{first_name[0]}#{last_name}", 
      "#{first_name}#{last_name[0]}", 
      "#{first_name[0..1]}#{last_name}", 
      "#{first_name}#{last_name[0..1]}", 
      "#{first_name[0..2]}#{last_name}", 
      "#{first_name}#{last_name[0..2]}", 
      "#{first_name[0..3]}#{last_name}", 
      "#{first_name}#{last_name[0..3]}"
    ]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin_scope(model_collection)
    if self.role == 'campus_manager'
      collection = model_collection.to_s
      self.school.public_send(collection)
    else
      model = model_collection.to_s.humanize.chop.constantize
      model.all
    end
  end

end
