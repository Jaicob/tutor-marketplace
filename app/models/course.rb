# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  school_id     :integer
#  subject       :text
#  call_number   :string
#  friendly_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Course < ActiveRecord::Base
  belongs_to :school
  has_many :tutor_courses, dependent: :destroy
  has_many :tutors, through: :tutor_courses, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :call_number, presence: :true
  validates :friendly_name, presence: :true
  validates :school_id, presence: :true
  validates :subject, presence: true

  before_create :set_empty_hash_for_subject

  serialize :subject, Hash

  def school_name
    school = School.find(self.school_id)
    school.name
  end

  def set_empty_hash_for_subject
    self.subject = {name: 'placeholder_name', id: 00}
  end

  def set_subject(name)
    self.subject[:name] = name
    case
      when name == 'Biology'          then id = 1
      when name == 'Chemistry'        then id = 2
      when name == 'Math'             then id = 3
      when name == 'Computer Science' then id = 4
      when name == 'Physics'          then id = 5
    end
    self.subject[:id] = id
    self.save
  end

  def formatted_name
    "#{self.subject[:name]} #{self.call_number}: #{self.friendly_name}"
  end

  def self.set_variables_for_create_course_list(params)
    @school_id = School.find_by(name: params[:school_name]).id
    @subject = params[:subject]
    @course_list = params[:create_course_list]
    @n = 1
  end

  def self.create_course_list(params)
    set_variables_for_create_course_list(params)
    @course_list.length.to_i.times do
      course = Course.create(
        school_id: @school_id,
        subject: {name: 'placeholder_name', id: 0},
        call_number: @course_list["course_#{@n}"]['call_number'].to_i,
        friendly_name: @course_list["course_#{@n}"]['friendly_name']
        ) 
      course.set_subject(@subject)
      @n += 1
    end
  end

end

