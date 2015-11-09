# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Info for 4 schools
school_list = [
  [ "University of North Carolina", "Chapel Hill, NC", 17.5 ],
  [ "University of Georgia", "Athens, GA", 17.5 ],
  [ "Duke University", "Durham, NC", 17.5 ],
  [ "Clemson University", "Clemson, SC", 17.5 ]
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

# Create a Course for each School
course_list.each do |school_id, subject_id, call_number, friendly_name|
  x = Course.create!(school_id: school_id, subject_id: subject_id, call_number: call_number, friendly_name: friendly_name)
end

# Create 20 Users to become Tutors, 5 for each school
n = 0
4.times{
  n += 1
  10.times{
    User.create!(
      school_id: n,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.safe_email,
      password: 'password',
      password_confirmation: 'password')
  }
}

# Create a Tutor profile for each User
## Arrays for calling the sample method on below to have nice mock tutor cards
extra_info = ['This is a short extra info example.', 'This is a medium extra info example for showing different possibilities.', "This is a really long extra info example for showing the possiblity of having a long enough statement that some is hidden and must be viewed on the actual profile."]
degree = [0,1,2,3,4,5]
major = ['Chemistry', 'Biology', 'Business', 'English', 'Micro-Biology', 'Computer Science', 'Accounting']
graduation_year = [2015, 2016, 2017, 2018, 2019]

User.all.each do |user|
  user.create_tutor(
    rating: 5,
    birthdate: '1990-01-01',
    degree: degree.sample,
    major: major.sample,
    major_2: major.sample,
    extra_info_1: extra_info.sample,
    extra_info_2: extra_info.sample,
    extra_info_3: extra_info.sample,
    graduation_year: graduation_year.sample,
    phone_number: Faker::Number.number(10)
    )
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
  slot_creator = SlotCreator.new(tutor_id: tutor.id, start_time: '2015-08-01 12:00', duration: 7200, weeks_to_repeat: 18)
  slot_creator.create_slots
end

# Create 20 Users to become Students, 5 for each school
n = 0
4.times{
  n += 1
  5.times{
    User.create!(
      school_id: n,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.safe_email,
      password: 'password',
      password_confirmation: 'password')
  }
}

new_users = []

User.all.each do |user|
  new_users << user if user.tutor == nil
end

new_users.each do |new_user|
  new_user.create_student
end


# Create an appointment for each student and tutor at each school
School.all.each do |school|
  @students = school.students
  @tutors = school.tutors
  5.times { |ordinal|
    Appointment.create(
      student_id: @students[ordinal].id,
      slot_id: @tutors[ordinal].slots.first.id,
      course_id: @tutors[ordinal].courses.first.id,
      start_time: "2015-08-01 12:00:00"
    )
  }
end

# Created an already confirmed login for development
# => nic@axontutors.com
# => password
test_user = User.create(
  school_id: 1,
  first_name: 'Nicolas',
  last_name: 'Cage',
  email: 'nic@axontutors.com',
  password: 'password',
  password_confirmation: 'password',
  role: 3
  )
test_user.skip_confirmation!
test_user.save