# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file .env file.


school_list = [
  [ "University of North Carolina", "Chapel Hill, NC" ],
  [ "University of Georgia", "Athens, GA" ],
  [ "Duke University", "Durham, NC" ],
  [ "Clemson University", "Clemson, SC" ]
]

school_list.each do |name, location|
  School.create( name: name, location: location )
end

subject_list = ["CHEM", "MATH", "BIOL", "ACCT", "PHYS", "CSCI", "STAT", "FINA"]

subject_list.each do |subject|
  Subject.create( name: subject )
end

# 1 and 1 refer respectively to a school_id and a subject_id currently in the DB, 
# these are otherwise arbitrary values
course_list = [
  [1, 1, "101", "Intro to Something"],
  [1, 1, "202", "Intermediate Something"],
  [1, 1, "303", "Advanced Something"],
  [1, 1, "9999", "Rocket Fucking Science"]
]

course_list.each do |school_id, subject_id, call_number, friendly_name|
  Course.create(school_id: school_id, subject_id: subject_id, call_number: call_number, friendly_name: friendly_name)
end

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
