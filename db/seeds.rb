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

course_list = [
  ["101", "Intro to Something"],
  ["202", "Intermediate Something"],
  ["303", "Advanced Something"],
  ["9999", "Rocket Fucking Science"]
]

course_list.each do | call_number, friendly_name |
  Course.create(call_number: call_number, friendly_name: friendly_name)
end
