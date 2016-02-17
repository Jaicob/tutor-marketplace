# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  code             :string
#  issuer           :integer
#  amount           :integer
#  valid_from       :date
#  valid_until      :date
#  redemption_limit :integer
#  redemption_count :integer          default(0)
#  description      :text
#  tutor_id         :integer
#  course_id        :integer
#  repeat_use       :integer          default(0)
#  student_id       :integer
#  single_appt      :integer
#  redeemer         :integer
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
    tutor_id          nil
    course_id         nil
    redeemer          0
    student_id        nil
    single_appt       0
    repeat_use        0

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

    trait :expired do 
      valid_until Date.today - 1
    end

    trait :reached_redemption_limit do
      redemption_limit  1
      redemption_count  1
    end

    trait :tutor_issued do
      issuer 1
      tutor_id 1
      # redeemer_restrictions 1
      student_id 1
    end

    trait :tutor_and_course_specific do
      issuer 1
      tutor_id 1
      course_id 1
      # redeemer_restrictions 1
      student_id 1
    end

    trait :tutor_multiple_appts do 
      issuer 1
      single_appt 1
      tutor_id 1
    end
    
    trait :tutor_single_appt_50 do
      issuer 1
      tutor_id 1
      amount 50
    end

    trait :tutor_single_appt_25 do
      issuer 1
      tutor_id 1
      amount 25
    end
  end
end
