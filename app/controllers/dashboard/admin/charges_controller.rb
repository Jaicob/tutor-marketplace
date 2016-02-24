class Dashboard::Admin::ChargesController < AdminController

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:charges).ransack(params[:q])
    @charges_total = @q.result.includes(:tutor, :student).order(created_at: :desc)
    @charges = @charges_total.page(params[:page])
  end

  def show
    @charge = Charge.find(params[:id])
  end
end