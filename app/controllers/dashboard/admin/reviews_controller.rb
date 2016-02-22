class Dashboard::Admin::ReviewsController < AdminController
  before_action :set_review, only: [:show, :update]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:reviews).ransack(params[:q])
    @reviews = @q.result.page(params[:page])
  end

  def show
  end

  def update
    if @review.update(review_params)
      flash[:success] = "Review was updated!"
      redirect_to admin_review_path(@review)
    else
      flash[:error] = "Review was not updated: #{@review.errors.full_messages}"
      render :index
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:follow_up_status, :follow_up_notes)
  end

end