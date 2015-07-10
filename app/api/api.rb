class API < Grape::API
  prefix 'api'
  format :json
  mount V1::Courses
  mount V1::Schools
  mount V1::Subjects
  mount V1::TutorCourses
  mount V1::Tutors
  mount V1::Users
  mount V1::ScheduleBlocks
end