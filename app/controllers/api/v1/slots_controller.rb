class API::V1::SlotsController < API::V1::Defaults
  before_action :set_tutor
  before_action :restrict_to_resource_owner, only: [:create, :update, :destroy]
  before_action :set_slot, only: [:update, :destroy]

  def index
    @slots = @tutor.slots
    respond_with(@slots)
  end

  def create
    @slot = @tutor.slots.new(slot_params)
    if @slot.save
      respond_with(@slot)
    else
      respond_with(status: 400)
    end
  end

  def update
    if @slot.update(slot_params)
      respond_with(@slot)
    else
      respond_with(status: 400)
    end
  end

  def destroy
    # Not sure what to return here with an if/else based on successful destroy operation - for a destroy method in an API...?
    @slot.destroy
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

    def slot_params
      params.require(:slot).permit(:tutor_id, :status, :start_time, :duration, :reservation_min, :reservation_max)
    end

end