module V1
  class Subjects < Grape::API

    include V1::Defaults

    resource :subjects do 
      desc "Returns list of all subjects"
      get do
        Subject.all.as_json
      end

      desc "Returns a specific subject"
      get ":id" do 
        Subject.find(params[:id]).as_json
      end

      desc "Updates a specific subject's attributes"
      put ":id" do
        @subject = Subject.find(params[:id])
        if @subject.update_attributes(params)
          return @subject.as_json
        else
          return "There was an error updating the tutor."
        end
      end
    end
  end
end