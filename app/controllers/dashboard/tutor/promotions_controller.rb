class Dashboard::Tutor::PromotionsController < DashboardController
  before_action :set_promotion, only: [:show, :update, :destroy]
  before_action :set_course_collection, only: [:index, :show]

  def index
    @promotions = @tutor.promotions
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.create(promotion_params)

    if @promotion.save
      redirect_to tutor_promotions_path(@tutor.slug)
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
      redirect_to tutor_promotion_path(@tutor.slug, @promotion)
    else
      flash[:error] = "Promotion was not updated: #{@promotion.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @promotion.destroy
      redirect_to dashboard_promotions_user_path
    else
      render :show
    end
  end

  private

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params.require(:promotion).permit(:category, :amount, :valid_from, :valid_until, :redemption_limit, :course_id, :description, :tutor_id)
    end

    def set_course_collection
      course_options = @tutor.tutor_courses.map{|tc| [tc.course.friendly_name, tc.course.id]}
      @course_collection = course_options.unshift(['Any Course', nil])
    end
    
end