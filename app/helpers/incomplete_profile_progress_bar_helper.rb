module IncompleteProfileProgressBarHelper

  def check_profile_progress
    tutor = current_user.tutor
    @user = current_user
    
    @degree =           tutor.profile_check(:degree)
    @major =            tutor.profile_check(:major)
    @extra_info =       tutor.profile_check(:extra_info)
    @graduation_year =  tutor.profile_check(:graduation_year)
    @phone_number =     tutor.profile_check(:phone_number)
    @birthdate =        tutor.profile_check(:birthdate) 
    @profile_pic =      tutor.profile_check(:profile_pic)
    @appt_notes =       tutor.profile_check(:appt_notes)
    @transcript =       tutor.profile_check(:transcript)

    @check = '<i class="fi-check progress-icon check"></i>' 
    @blank = '<i class="fi-plus progress-icon blank"></i>'
  end
end