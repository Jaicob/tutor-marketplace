require 'doorkeeper/grape/helpers'

module V1
  class Subjects < Grape::API

    include V1::Defaults

      params do 
        optional :name, type: String
      end

      helpers Doorkeeper::Grape::Helpers

      before do
          doorkeeper_authorize!
      end

    resource :schools do

      desc "Returns a school and all of its subjects"
      get ":id/subjects" do 
        school = School.find(params[:id])
        school.subjects
      end

    end
  end
end