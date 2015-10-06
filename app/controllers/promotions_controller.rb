class PromotionsController < ApplicationController
  before_action :set_promotion, only: [:show, :edit, :destroy]

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
      params.require(:promotion).permit(:code, :category, :amount, :valid_from, :valid_until, :redemption_limit)
    end
    
end