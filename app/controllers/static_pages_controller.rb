class StaticPagesController < ApplicationController

  def home
    @sign_up_path = if user_signed_in? then '/tutors/new' else '/tutors/visitor_new' end
  end

  def dashboard_placeholder
    @tutor = Tutor.find(params[:id])
  end
  
end