class API::V1::SlotsController < API::V1::Defaults
  before_action :set_tutor
  before_action :restrict_to_resource_owner, only: [:create, :update, :destroy]
  before_action :set_slot, only: [:show, :update, :destroy]

  def index
    @slots = @tutor.slots
    respond_with(@slots)
  end

  def show
    respond_with(@slot)
  end

  def create
    @slot = @tutor.slots.new(safe_params)
    if @slot.save
      respond_with(@slot)
    else
      respond_with(status: 400)
    end
  end

  def update
    if @slot.update(safe_params)
      render json: @slot, status: 200
    else
      render nothing: true, status: 500
    end
  end

  def destroy
    if @slot.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 500
    end
  end

  private

    def restrict_to_resource_owner
      if current_user.tutor != @tutor
        return redirect_to restricted_access_path, status: 401
      end
    end

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

    def set_slot
      @slot = Slot.find(params[:id])
    end

    def safe_params
      hash = {}
      hash[:tutor_id] = params[:tutor_id] if params[:tutor_id]
      hash[:status] = params[:status] if params[:status]
      hash[:start_time] = params[:start_time] if params[:start_time]
      hash[:duration] = params[:duration] if params[:duration]
      hash[:reservation_min] = params[:reservation_min] if params[:reservation_min]
      hash[:reservation_max] = params[:reservation_max] if params[:reservation_max]
      return hash
    end 

end