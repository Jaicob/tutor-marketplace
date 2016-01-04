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
#  payment_info           :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  sign_in_ip             :string
#

class User < ActiveRecord::Base
  has_one :tutor, dependent: :destroy
  has_one :student, dependent: :destroy
  has_one :campus_manager, dependent: :destroy
  has_one :admin, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  enum role: [:student, :tutor, :campus_manager, :admin]

  devise :async, :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def create_tutor_account(user, params)
    # used in Devise::RegistrationsController to create a Tutor while creating a User
    user.create_tutor!(
      phone_number: params[:user][:tutor][:phone_number],
      school_id: params[:user][:tutor][:school_id]
    )
    # send welcome email
    TutorManagementMailer.delay.welcome_email(user.id)
  end

  def create_student_account(user, params)
    # used in Devise::RegistrationsController to create a Student while creating a User
    user.create_student!(
      school_id: params[:user][:student][:school_id]
    ) 
    # additional logic for sign-up during checkout below, creates a Stripe customer and saves default_card
    # - used for checkout via AJ's React component only
    # - checkout via JT's forms does not use Devise controllers and handle student and Stripe customer creation through Checkout controller and CheckoutRegistration service class
    if params[:stripe_token] && params[:save_card] == 'true'
      Processor::Stripe.new.update_customer(self, params[:stripe_token])
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin_scope(model_collection)
    # only return tutors/appointments/etc. from one school for campus_manager
    if self.role == 'campus_manager'
      collection = model_collection.to_s
      self.school.public_send(collection)
    else
    # return tutors/appointments/etc. from all schools for super_admin
      model = model_collection.to_s.humanize.chop.constantize
      model.all
    end
  end

  def school
    case self.role.to_sym
    when :student
      return self.student.school
    when :tutor
      return self.tutor.school
    when :campus_manager
      return self.campus_manager.school
    end
  end

end
