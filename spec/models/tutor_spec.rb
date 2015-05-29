# == Schema Information
#
# Table name: tutors
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  rating          :integer
#  status          :integer
#  birthdate       :date
#  degree          :string
#  major           :string
#  extra_info      :string
#  graduation_year :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Tutor, type: :model do
end
