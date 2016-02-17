class StudentsPromotions < ActiveRecord::Base
  belongs_to :student
  belongs_to :promotion
end
