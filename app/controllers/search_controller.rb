class SearchController < ApplicationController
  respond_to :json

  def search_from_home
    search_hash = {}
    search_hash[:indirect_search] = true # this means a search that was not initiated from the main search page (i.e. from the Home page or the back button on a tutor's profile reached from search results)
    search_hash[:course_id] = params[:course][:course_id]
    redirect_to search_path(search_hash)
  end

end