class Dashboard::Admin::PromotionsController < AdminController
  before_action :set_promotion, only: [:show, :edit, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:promotions).ransack(params[:q])
    @promotions = @q.result.page(params[:page])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.create(promotion_params)

    if @promotion.save
      redirect_to admin_promotion_path(@promotion)
    else
      flash[:error] = "Promotion was not created: #{@promotion.errors.full_messages}"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @promotion.update(promotion_params)
      redirect_to admin_promotion_path(@promotion)
    else
      flash[:error] = "Promotion was not updated: #{@promotion.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @promotion.destroy
      redirect_to admin_promotions_path
    else
      render :show
    end
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(:code, :category, :amount, :valid_from, :valid_until, :redemption_limit, :description, :issuer, :single_appt, :redeemer, :repeat_use)
  end

end
