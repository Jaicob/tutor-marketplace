class API::V1::SearchController < API::V1::Defaults

  def tutors
    tutorSearch = TutorSearch.new(params)
    @results = tutorSearch.search 
    puts "RESULTS!!!!! = #{@results}"
    if @results
      respond_with(@results)
    else
      return "Problem fetching tutors: #{@results.errors.full_messages}"
    end 
  end

end