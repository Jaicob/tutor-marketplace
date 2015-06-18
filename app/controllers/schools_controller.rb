class SchoolsController < ApplicationController

  def index
    @schools =  if params[:id]
      School.find(params[:id])
    else
      School.all
    end
    render json: @schools.as_json
  end

end
