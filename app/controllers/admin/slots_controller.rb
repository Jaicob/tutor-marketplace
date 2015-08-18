class Admin::SlotsController < AdminController

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:slots).ransack(params[:q])
    @slots = @q.result.includes(:tutor, :appointments)
  end
  
end
