class UsersController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def update
    if @user.update(user_params)
      redirect_to dashboard_settings_user_path(current_user)
    else
      flash[:notice] = "There was an error updating your settings."
      redirect to  dashboard_settings_user_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :slug, :first_name, :last_name)
  end

end
