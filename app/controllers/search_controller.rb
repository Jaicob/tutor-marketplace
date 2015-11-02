class SearchController < ApplicationController
  respond_to :json

  def search_from_home
    search_hash = {}
    search_hash[:from_home] = true 

    if params[:course][:school_id]
      search_hash[:school_id] = params[:course][:school_id]
    end
    if params[:course][:subject_id]
      search_hash[:subject_id] = params[:course][:subject_id]
    end
    if params[:course][:course_id]
      search_hash[:course_id] = params[:course][:course_id]
    end
    
    puts "SEARCH HASH = #{search_hash}"

    redirect_to search_path(search_hash)
  end

end