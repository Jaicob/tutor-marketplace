module V1
  class Searches < Grape::API

    include V1::Defaults

      params do 
        optional  :dow,                type: String
        optional  :course_id,          type: String
        optional  :school_id,          type: String
      end

    resource :search do 

      desc "Searches for tutors based on params"
      get "tutors" do
        tutorSearch = TutorSearch.new(declared_params)
        @results = tutorSearch.search 
        if @results
          @results
        else
          return "Problem fetching tutors: #{@results.errors.full_messages}"
        end        
      end
      
    end
  end
end