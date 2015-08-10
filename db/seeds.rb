# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Info for 4 schools
school_list = [
  [ "University of North Carolina", "Chapel Hill, NC" ],
  [ "University of Georgia", "Athens, GA" ],
  [ "Duke University", "Durham, NC" ],
  [ "Clemson University", "Clemson, SC" ]
] 

# Create Schools out of the school_list
school_list.each do |name, location|
  School.create(name: name, location: location)
end

# Creates Courses for each of the 4 Schools
course_list = [
  [1, {name: 'Biology', id: 1}, "101", "Intro to Biology (U1)"],
  [1, {name: 'Chemistry', id: 2}, "101", "Intro to Chemistry (U1)"],
  [1, {name: 'Math', id: 3}, "101", "Intro to Math (U1)"],
  [1, {name: 'Computer Science', id: 4}, "101", "Intro to Computer Science (U1)"],
  [1, {name: 'Physics', id: 5}, "101", "Intro to Physics (U1)"],
  [2, {name: 'Biology', id: 1}, "101", "Intro to Biology (U2)"],
  [2, {name: 'Chemistry', id: 2}, "101", "Intro to Chemistry (U2)"],
  [2, {name: 'Math', id: 3}, "101", "Intro to Math (U2)"],
  [2, {name: 'Computer Science', id: 4}, "101", "Intro to Computer Science (U2)"],
  [2, {name: 'Physics', id: 5}, "101", "Intro to Physics (U2)"],
  [3, {name: 'Biology', id: 1}, "101", "Intro to Biology (U3)"],
  [3, {name: 'Chemistry', id: 2}, "101", "Intro to Chemistry (U3)"],
  [3, {name: 'Math', id: 3}, "101", "Intro to Math (U3)"],
  [3, {name: 'Computer Science', id: 4}, "101", "Intro to Computer Science (U3)"],
  [3, {name: 'Physics', id: 5}, "101", "Intro to Physics (U3)"],
  [4, {name: 'Biology', id: 1}, "101", "Intro to Biology (U4)"],
  [4, {name: 'Chemistry', id: 2}, "101", "Intro to Chemistry (U4)"],
  [4, {name: 'Math', id: 3}, "101", "Intro to Math (U4)"],
  [4, {name: 'Computer Science', id: 4}, "101", "Intro to Computer Science (U4)"],
  [4, {name: 'Physics', id: 5}, "101", "Intro to Physics (U4)"]
]

# Create a Course for each School
course_list.each do |school_id, subject, call_number, friendly_name|
  Course.create(school_id: school_id, subject: {name: subject[:name], id: subject[:id]}, call_number: call_number, friendly_name: friendly_name)
end

# Create 20 Users to become Tutors, 5 for each school
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

# Create a Tutor profile for each User
User.all.each do |user|

  user.create_tutor(
    rating: 5,
    birthdate: '1990-01-01',
    degree: 'B.A.', 
    major: 'Marine Biology', 
    extra_info: Faker::Lorem.sentence, 
    graduation_year: '2018', 
    phone_number: Faker::Number.number(10), 
    transcript: File.new(File.join(Rails.root, 'app/assets/images/file-icon.png'))
    )
end

# Create 3 TutorClasses for each Tutor
Tutor.all.each do |tutor|
  tutor.tutor_courses.create(course_id: tutor.school.courses.first, rate: 15)
  tutor.tutor_courses.create(course_id: tutor.school.courses.second, rate: 20)
  tutor.tutor_courses.create(course_id: tutor.school.courses.third, rate: 25)
  tutor.tutor_courses.create(course_id: tutor.school.courses.fourth, rate: 30)
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
      school_id: 1, 
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

# Create an appointment for each student
n = 1
Student.all.each do |student|
  student.appointments.create(slot_id: n, start_time: '2015-08-01 12:00')
  n += 18
end

# # Create appointments at each school 
# School.all.each do |school|
#   school.students.each do |student|
#     student.appointments.create(slot_id: n, start_time: '2015-08-01')
#   end
# end

# [[1, "University of North Carolina"], [19, "University of North Carolina"], [37, "University of North Carolina"], [55, "University of North Carolina"], [73, "University of North Carolina"], [91, "University of North Carolina"], [109, "University of Georgia"], [127, "University of Georgia"], [145, "University of Georgia"], [163, "University of Georgia"], [181, "University of Georgia"], [199, "Duke University"], [217, "Duke University"], [235, "Duke University"], [253, "Duke University"], [271, "Duke University"], [289, "Clemson University"], [307, "Clemson University"], [325, "Clemson University"], [343, "Clemson University"], [361, "Clemson University"]]
