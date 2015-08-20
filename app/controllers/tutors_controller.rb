class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :update_settings, :destroy, :create_tutor_course]
  before_action :set_tutor_for_admin_or_visitor_sign_up, only: [:register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :update_active_status, :destroy_by_admin]

  def index
    @tutors = Tutor.all
    respond_to do |format|
      format.html
      format.csv { send_data @tutors.to_csv, filename: "tutors-#{Date.today}.csv" }
    end
  end

  def new
    @tutor = Tutor.new
    @tutor.tutor_courses.build
    @tutor.courses.build
  end

  def create
    @user = User.create(tutor_params[:user])
    puts @user.errors.full_messages
    @tutor = @user.create_tutor(tutor_params)

    puts "Tutor Params = #{tutor_params}"


    if @tutor.save
      # The method below only creates a tutor_course for the initial sign-up, all other CRUD operations relating to tutor_courses go through the TutorCoursesController
      @tutor.set_first_tutor_course(@tutor, params)
      redirect_to dashboard_home_user_path(current_user)
    else
      flash[:alert] = "Tutor account was not created. Please fill in all fields and attach your unofficial transcript."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    if @tutor.save
      redirect_to dashboard_profile_user_path(current_user)
    else
      flash[:notice] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      redirect_to :back
    end
  end

  # This is identical to the above Update action except that it redirects to the Dashboard Settings page rather than to a Tutor's profile. This action is used for updating a Tutor's birthdate and phone_number on the Dashboard Settings page.
  def update_settings
    @tutor.update(tutor_params)
    if @tutor.save
      redirect_to dashboard_settings_user_path(current_user)
    else
      flash[:notice] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    if @tutor.destroy
      redirect_to dashboard_home_user_path(current_user)
    else
      flash[:alert] = "Your tutor account was not deleted."
      render :show
    end
  end

  private

    def tutor_params
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate], user: [:first_name, :last_name, :email, :password, :password_confirmation])
    end

    def set_tutor_for_admin_or_visitor_sign_up
      @tutor = Tutor.find(params[:id])
    end

end


# Parameters: 

#   "tutor"=>{
#     "user"=>{
#       "first_name"=>"JT", 
#       "last_name"=>"Jobe", 
#       "email"=>"jtjobe@gmail.com", 
#       "password"=>"[FILTERED]", 
#       "password_confirmation"=>"[FILTERED]"}, 
#     "extra_info"=>"hey"}, 
#     "course"=>{
#       "schoold_id"=>"1", 
#       "subject_id"=>"1", 
#       "course_id"=>"1"}, 
#     "tutor_course"=>{
#       "rate"=>"23"
