module IncompleteProfileProgressBarHelper

  def check_profile_progress
    tutor = current_user.tutor
    @user = current_user

    @public_info =      tutor.profile_check(:public_info)
    @private_info =     tutor.profile_check(:private_info)
    @profile_pic =      tutor.profile_check(:profile_pic)
    @appt_notes =       tutor.profile_check(:appt_notes)
    @transcript =       tutor.profile_check(:transcript)
    @payment_info =     tutor.profile_check(:payment_info)

    @check = '<i class="fi-check progress-icon check"></i>' 
    @blank = '<i class="fi-plus progress-icon blank"></i>'
  end
end