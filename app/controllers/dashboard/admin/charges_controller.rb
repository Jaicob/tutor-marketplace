class Dashboard::Admin::ChargesController < AdminController

  def index
    @charges = Charge.all
  end

  def show
    @charge = Charge.find(params[:id])
  end
end