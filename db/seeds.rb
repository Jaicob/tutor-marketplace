# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Info for 4 schools
school_list = [
  [ "University of North Carolina", "Chapel Hill, NC", 15 ],
  [ "University of Georgia", "Athens, GA", 15 ],
  [ "Duke University", "Durham, NC", 15 ],
  [ "Clemson University", "Clemson, SC", 15 ]
]

# Create Schools out of the school_list
school_list.each do |name, location, tp|
  School.create(name: name, location: location, transaction_percentage: tp)
end

subject_list = %w(Biology Chemistry Math Computer\ Science Physics)

subject_list.each do |name|
  Subject.create(name: name)
end

# Creates Courses for each of the 4 Schools
course_list = [
  [1, 1, "101", "Intro to Biology (U1)"],
  [1, 2, "101", "Intro to Chemistry (U1)"],
  [1, 3, "101", "Intro to Math (U1)"],
  [1, 4, "101", "Intro to Computer Science (U1)"],
  [1, 5, "101", "Intro to Physics (U1)"],
  [2, 1, "101", "Intro to Biology (U2)"],
  [2, 2, "101", "Intro to Chemistry (U2)"],
  [2, 3, "101", "Intro to Math (U2)"],
  [2, 4, "101", "Intro to Computer Science (U2)"],
  [2, 5, "101", "Intro to Physics (U2)"],
  [3, 1, "101", "Intro to Biology (U3)"],
  [3, 2, "101", "Intro to Chemistry (U3)"],
  [3, 3, "101", "Intro to Math (U3)"],
  [3, 4, "101", "Intro to Computer Science (U3)"],
  [3, 5, "101", "Intro to Physics (U3)"],
  [4, 1, "101", "Intro to Biology (U4)"],
  [4, 2, "101", "Intro to Chemistry (U4)"],
  [4, 3, "101", "Intro to Math (U4)"],
  [4, 4, "101", "Intro to Computer Science (U4)"],
  [4, 5, "101", "Intro to Physics (U4)"]
]

# Create a Course for each School using course_list above
course_list.each do |school_id, subject_id, call_number, friendly_name|
  x = Course.create!(school_id: school_id, subject_id: subject_id, call_number: call_number, friendly_name: friendly_name)
end

# Create 100 Users to become Tutors
100.times{
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.safe_email(SecureRandom.hex(8).to_s),
    password: 'password',
    password_confirmation: 'password')
}

# Create a Tutor profile for each User
## Arrays for calling the sample method on below to have nice mock tutor cards
extra_info = ['This is a short extra info example for showing different possibilities.', "This is a long extra info example for showing the possiblity of having a long enough statement that some is hidden and must be viewed on the actual profile."]
degree = [0,1,2,3,4,5]
major = ['Chemistry', 'Biology', 'Business', 'English', 'Micro-Biology', 'Computer Science', 'Accounting']
graduation_year = [2015, 2016, 2017, 2018, 2019]
additional_degrees = [
  'B.A. Accounting, B.S. Finance',
  'M.F.A English, B.S. Spanish',
  'B.S. Biology, B.A. Marine Biology',
  'B.S. Chemistry, B.S. Micro-Biology'
]

n = 1
User.all.each do |user|
  user.create_tutor!(
    school_id: n,
    rating: 5,
    degree: degree.sample,
    major: major.sample,
    additional_degrees: additional_degrees.sample,
    extra_info_1: extra_info.sample,
    extra_info_2: extra_info.sample,
    extra_info_3: extra_info.sample,
    graduation_year: graduation_year.sample,
    phone_number: Faker::Number.number(10)
  )
  x = Tutor.count
  if (x == 25) || (x == 50) || (x == 75)
    n += 1
  end
end

# Remove additional degrees from every second and third tutor
Tutor.all.each do |tutor|
  if tutor.id % 2 == 0 || tutor.id % 3 == 0
    tutor.additional_degrees = nil
    tutor.save
  end
end

# Create 3 TutorCourses for each Tutor
rates =[15,18,20,22,25,26,30,31]
Tutor.all.each do |tutor|
  tutor.tutor_courses.create(course_id: tutor.school.courses.first.id, rate: rates.sample)
  tutor.tutor_courses.create(course_id: tutor.school.courses.second.id, rate: rates.sample)
  tutor.tutor_courses.create(course_id: tutor.school.courses.third.id, rate: rates.sample)
  tutor.tutor_courses.create(course_id: tutor.school.courses.fourth.id, rate: rates.sample)
end

# Create Slots for each Tutor
Tutor.all.each do |tutor|
  start_time = Date.today.to_s + ' 12:00'
  slot_creator = SlotCreator.new(tutor_id: tutor.id, start_time: start_time, duration: 7200, weeks_to_repeat: 18, slot_type:0)
  slot_creator.create_slots
end

# Activate tutors
Tutor.all.each do |tutor|
  tutor.update(active_status: 1)
end

# Create 200 Users to become Students, 25 for each school
100.times{
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.safe_email(SecureRandom.hex(8).to_s),
    password: 'password',
    password_confirmation: 'password')
}

new_users = []

User.all.each do |user|
  new_users << user if user.tutor == nil
end

n = 1
new_users.each do |new_user|
  new_user.create_student!(school_id: n)
  x = Student.count
  if (x == 25) || (x == 50) || (x == 75)
    n += 1
  end
end

# Create an appointment for each student and tutor at each school
School.all.each do |school|
  @students = school.students
  @tutors = school.tutors
  @start_time = Date.today.to_s + ' 12:00'
  25.times { |ordinal|
    Appointment.create(
      student_id: @students[ordinal].id,
      slot_id: @tutors[ordinal].slots.first.id,
      course_id: @tutors[ordinal].courses.first.id,
      start_time: @start_time
    )
  }
end