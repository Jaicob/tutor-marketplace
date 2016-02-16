# == Schema Information
#
# Table name: promotions
#
#  id                    :integer          not null, primary key
#  code                  :string
#  issuer                :integer
#  amount                :integer
#  valid_from            :date
#  valid_until           :date
#  redemption_limit      :integer
#  redemption_count      :integer          default(0)
#  description           :text
#  tutor_id              :integer
#  course_id             :integer
#  reedemer_restrictions :integer          default(0)
#  student_group_id      :integer
#  student_id            :integer
#

FactoryGirl.define do
  factory :promotion do
    code              'AXON10%OFF'
    issuer            0       # 0 = Axon, 1 = Tutor
    amount            10      # Percent off as integer
    valid_from        Date.today
    valid_until       Date.today + 100
    redemption_limit  100
    redemption_count  0
    description       '10% off one session'
    tutor
    course_id         nil
    single_appt       0
    student_uniq      0

    trait :free_from_axon do 
      amount 100
      description 'Free Session from Axon'
    end

    trait :ten_percent_off_from_axon do 
      amount 10
      description '10% Off from Axon'
    end

    trait :ten_percent_off_from_tutor do 
      issuer 1
      amount 10
      description '10% Off from Tutor'
    end
  end
end
