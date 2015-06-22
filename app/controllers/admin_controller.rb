class AdminController < ApplicationController

  def tutors
    @tutors = Tutor.all
  end


end
