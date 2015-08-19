module IncompleteProfileProgressBarHelper

  def check_profile_progress
    tutor = current_user.tutor
    @first_name = current_user.first_name
    
    @degree =           tutor.profile_check(:degree)
    @major =            tutor.profile_check(:major)
    @extra_info =       tutor.profile_check(:extra_info)
    @graduation_year =  tutor.profile_check(:graduation_year)
    @phone_number =     tutor.profile_check(:phone_number)
    @birthdate =        tutor.profile_check(:birthdate) 
    @profile_pic =      tutor.profile_check(:profile_pic)
    @appt_notes =       tutor.profile_check(:appt_notes)
  end
end