class SearchController < ApplicationController
  respond_to :json

  def search_from_home
    # if request.referer == root_url
      puts "request_referer_data_type = #{request.referer.class}"
      puts "request.referer = #{request.referer}"
      puts "CALLED!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "CALLED!!!!!!!!!!!!!!!!!!!!!!!!!!"
      search_hash = {}
      search_hash[:indirect_search] = true # true means that search not initiated from the main search page (i.e. from the Home page or the back button on a tutor's profile reached from search results)
      search_hash[:course_id] = params[:course][:course_id]
    # end
    redirect_to search_path(search_hash)
  end

end


#     | REQUEST REFERER: http://dockerhost:3000/search   !!!!!!!!!!!!
# web_1     | REQUEST REFERER: http://dockerhost:3000/search   !!!!!!!!!!!!