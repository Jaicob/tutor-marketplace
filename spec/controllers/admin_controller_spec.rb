require 'rails_helper'

describe AdminController do

  describe TutorsController do

    describe 'GET #index' do 
      it 'renders the :index template' do 
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

  end

end