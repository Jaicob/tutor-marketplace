class API::V1::SlotsController < API::V1::Defaults
  before_action :set_tutor
  before_action :restrict_to_resource_owner, only: [:create, :update, :destroy]

  def index
    @slots = @tutor.slots
    respond_with(@slots)
  end

  def create
    @slot = current_user.tutor.slots.new(slot_params)
    if @slot.save
      respond_with(@slot)
    else
      respond_with(status: 401)
    end
  end

  def update
    if current_user.tutor.slots.find(params[:id])
      @slot = current_user.tutor.slots.find(params[:id])
      if @slot.update(slot_params)
        respond_with(@slot)
      else
        respond_with(status: 401)
      end
    else
      respond_with(status: 401)
    end
  end

  def destroy
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

    def restrict_to_resource_owner
      if current_user.tutor != params[:tutor_id]
        return status 401
      end
    end

    def slot_params
      params.require(:slot).permit(:tutor_id, :status, :start_time, :duration, :reservation_min, :reservation_max)
    end

end