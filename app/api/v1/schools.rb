module V1
  class Schools < Grape::API

    include V1::Defaults

      helpers do 
        def school
          School.find(params[:id])
        end
      end

      params do 
        optional :name, type: String
        optional :location, type: String
      end

    resource :schools do 

      desc "Returns list of all schools"
      get do
        School.all
      end

      desc "Returns a school"
      get ":id" do 
        school
      end

      desc "Returns a school and all of its courses"
      get ":id/courses" do 
        school.courses
      end

      desc "Returns a school and all of its subjects"
      get ":id/subjects" do 
        school.subjects
      end

      desc "Returns a school and its courses for a subject"
      get ":id/subjects/:subject_id/courses" do 
        school.courses.find_all do |course| 
          course.subject[:id] == params[:subject_id].to_i
        end
      end

      desc "Creates a school"
      post do 
        @school = School.create(declared_params)
        if @school.save
          return @school
        else
          return "School was not created: #{@school.errors.full_messages}"
        end
      end

      # Update with PUT
      desc "Updates a school"
      put ":id" do
        @school = school
        if @school.update(params)
          return school.as_json
        else
          return "There was an error updating the school."
        end
      end

      # Update with PATCH
      desc "Updates a school"
      patch ":id" do
        @school = school
        if @school.update_attributes(params)
          return @school.as_json
        else
          return "There was an error updating the school."
        end
      end

      desc "Deletes a school"
      delete ":id" do 
        @school = school
        if @school.destroy
          return "School was succesfully destroyed."
        else
          return "School was not destroyed: #{@school.errors.full_messages}"
        end
      end

    end
  end
end