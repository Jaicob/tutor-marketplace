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
#  single_appt      :integer          default(0)
#  student_uniq     :integer          default(0)
#

FactoryGirl.define do
  factory :promotion do
    code 'AXON10%OFF'
    issuer 0       # 0 = Axon, 1 = Tutor
    amount 10      # Percent off as integer
    valid_from Date.today
    valid_until Date.today + 100
    redemption_limit 100
    redemption_count 0
    description '10% off one session'
    tutor
    course_id 1
    single_use 0    # 0 = true, 1 = false
  end

end
