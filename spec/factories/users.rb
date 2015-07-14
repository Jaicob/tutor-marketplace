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
#

FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    first_name "Bob"
    last_name "Dole"
    email "test@example.com"
    password "please123"
    slug "bobdole"

    trait :admin do
      role 'admin'
    end

    factory :alternate_user do
      confirmed_at Time.now
      first_name "Randy"
      last_name "Marsh"
      email "iamlorde@example.com"
      password "ohhhyeah"
      slug "iamlordelalala"
    end

    factory :second_alternate_user do 
      confirmed_at Time.now
      first_name "Ricky"
      last_name "Bobby"
      email "shakeandbake@example.com"
      password "babyjesus"
      slug "mountaindew"
    end
  end
end
