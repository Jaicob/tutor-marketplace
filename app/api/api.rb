# Go to swagger-ui client via docker container and enter http://dockerhost:3000/api/docs
require 'grape-swagger'


class API < Grape::API

  prefix 'api'
  format :json
  mount V1::Courses
  mount V1::Schools
  mount V1::TutorCourses
  mount V1::Tutors
  mount V1::Users
  mount V1::Slots
  mount V1::SlotManagers
  add_swagger_documentation  api_version: 'v1', mount_path: '/docs', base_path: 'api/v1' , info: {title: "Axon API"}

end
