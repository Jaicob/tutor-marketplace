module V1
  class Tutors < Grape::API

    include V1::Defaults

      helpers do 
        def tutor
          Tutor.find(params[:id])
        end
      end

      params do 
        optional  :id,                 type: Integer 
        optional  :user_id,            type: Integer    
        optional  :rating,             type: Integer  
        optional  :application_status, type: String
        optional  :active_status,      type: Integer
        optional  :birthdate,          type: String
        optional  :degree,             type: Integer
        optional  :major,              type: Integer
        optional  :extra_info,         type: Integer
        optional  :graduation_year,    type: String
        optional  :phone_number,       type: String
        optional  :profile_pic,        type: String
        optional  :transcript,         type: String
        optional  :dow,                type: Integer
        optional  :course_id,          type: Integer
        optional  :school_id,          type: Integer
      end

    resource :tutors do 

      desc "Returns list of all tutors"
      get do
        Tutor.all
      end

      desc "Returns a specific tutor"
      get ":id" do 
        tutor
      end

      desc "Updates a specific tutor's attributes"
      put ":id" do
        @tutor = tutor
        if @tutor.update_attributes(params)
          return @tutor
        else
          return "There was an error updating the tutor: #{@tutor.errors.full_messages}"
        end
      end

      desc "Searches for tutors based on params"
      get "search" do
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