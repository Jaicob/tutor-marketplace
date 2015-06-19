class AdminController < ApplicationController

  def tutors
    @tutors = Tutor.all
  end

  def update_tutor_active_status
    @tutor = Tutor.find(params[:tutor_id])
    if @tutor.update_attributes(active_status: params[:active_status])
      flash[:notice] = 'Tutor active status was succesfully updated.'
      redirect_to '/admin/tutors'
    else
      flash[:error] = 'Tutor active status was not updated.'
      redirect_to '/admin/tutors'
    end
  end

  def destroy_tutor
    @tutor = @tutor = Tutor.find(params[:tutor_id])
    if @tutor.destroy
      flash[:notice] = "Tutor account was succesfully deleted."
      redirect_to '/admin/tutors'
    else
      flash[:error] = "Tutor account was not deleted."
      redirect_to '/admin/tutors'
    end
  end

end
