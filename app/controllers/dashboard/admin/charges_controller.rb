class Dashboard::Admin::ChargesController < AdminController

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:charges).ransack(params[:q])
    @charges = @q.result.includes(:tutor, :student).page(params[:page])
  end

  def show
    @charge = Charge.find(params[:id])
  end
end