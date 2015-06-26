class StaticPagesController < ApplicationController

	def home
		@sign_up_path = if user_signed_in? then '/tutors/new' else '/tutors/visitor_new' end
	end

end
