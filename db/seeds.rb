# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#   user = CreateAdminService.new.call
#   puts 'CREATED ADMIN USER: ' << user.email
#   Environment variables (ENV['...']) can be set in the file .env file.


# Create 4 schools

school_list = [
  [ "University of North Carolina", "Chapel Hill, NC" ],
  [ "University of Georgia", "Athens, GA" ],
  [ "Duke University", "Durham, NC" ],
  [ "Clemson University", "Clemson, SC" ]
] 

school_list.each do |name, location|
  School.create(name: name, location: location)
end

# Creates courses for each of the 4 schools

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

course_list.each do |school_id, subject, call_number, friendly_name|
  Course.create(school_id: school_id, subject: {name: subject[:name], id: subject[:id]}, call_number: call_number, friendly_name: friendly_name)
end


# Create 20 Devise Users

20.times { User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, password: 'password', password_confirmation: 'password') }


# Create a Tutor profile for each User

User.all.each do |user|
  user.create_tutor(degree: 'B.A.', major: 'Marine Biology', extra_info: Faker::Lorem.sentence, graduation_year: '2018', phone_number: Faker::Number.number(10))
end


# Create 3 TutorClasses for each Tutor
Tutor.all.each do |tutor|
  tutor.tutor_courses.create(course_id: 1, rate: 25)
  tutor.tutor_courses.create(course_id: 2, rate: 30)
  tutor.tutor_courses.create(course_id: 3, rate: 35)
  tutor.tutor_courses.create(course_id: 4, rate: 35)
end

# Faker stuff
# Faker::Name.first_name
# Faker::Name.last_name
# Faker::Lorem.sentence
# Faker::Number.number(10)
# Faker::Internet.safe_email
# Faker::Date.backward(8000)
# Faker::Number.number(2)

# This creates a course of every subject and course above for each of the different schools
# Until we implement a JS solution to dynamically load the options on the forms, 
# a smaller data set is more manageable
#
# courses_with_subject_ids = []
# course_list.each do |call_number, friendly_name|
#   x = 1
#   while x <= 4 do
#     courses_with_subject_ids << [[x], ["#{call_number}"], ["#{friendly_name}"]]
#     x += 1
#   end
# end

# courses_with_subject_and_school_ids = []
# courses_with_subject_ids.each do |subject_id, call_number, friendly_name|
#   x = 1
#   while x <= 4 do 
#     courses_with_subject_and_school_ids << [[x], ["#{subject_id}"],["#{call_number}"], ["#{friendly_name}"]]
#     x += 1
#   end
# end

# courses_with_subject_and_school_ids.each do |school_id, subject_id, call_number, friendly_name| 
#   Course.create(school_id: school_id, subject_id: subject_id, call_number: call_number, friendly_name: friendly_name)
# end
