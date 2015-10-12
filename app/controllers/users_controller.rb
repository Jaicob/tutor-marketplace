class UsersController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def update
    if @user.update(user_params)
      if @user.tutor
        redirect_to account_tutor_path(current_user)
      else
        redirect_to account_student_path(current_user)
      end
    else
      flash[:notice] = "There was an error updating your settings."
      redirect_to :back
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :slug, :first_name, :last_name, :school_id)
    end

end
