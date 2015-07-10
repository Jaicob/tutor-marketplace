module V1
  class Schools < Grape::API

    include V1::Defaults

    resource :schools do 

      helpers do 
        def school
          School.find(params[:id])
        end
      end

      params do 
        requires :school, type: Hash do
          optional :name, type: String
        end
      end

      desc "Returns list of all schools"
      get do
        School.all
      end

      desc "Returns a specific school"
      get ":id" do 
        school
      end

      desc "Returns a specific school and all of its courses"
      get ":id/courses" do 
        school.courses
      end

      desc "Returns a specific school and all of its subjects"
      get ":id/subjects" do 
        school.subjects
      end

      desc "Returns a specific school and its courses for a specific subject"
      get ":id/subjects/:subject_id/courses" do 
        school.courses.find_all do |course| 
          course.subject_id == params[:subject_id].to_i
        end
      end

      # Update with PUT
      desc "Updates a specific school's attributes"
      put ":id" do
        { "declared_params" => declared(params) }
        # @school = school
        # if @school.update_attributes(declared(params))
        #   return @school.as_json
        # else
        #   return "There was an error updating the tutor."
        # end
      end

      # Update with PATCH
      desc "Updates a specific school's attributes"
      patch ":id" do
        @school = school
        if @school.update_attributes(declared(params))
          return @school.as_json
        else
          return "There was an error updating the tutor."
        end
      end



    end
  end
end