module IncompleteProfileProgressBarHelper

  def check_profile_progress
    tutor = current_user.tutor
    @user = current_user

    @public_info =      tutor.check_profile_for(:public_info)
    @private_info =     tutor.check_profile_for(:private_info)
    @profile_pic =      tutor.check_profile_for(:profile_pic)
    @appt_notes =       tutor.check_profile_for(:appt_settings)
    @transcript =       tutor.check_profile_for(:transcript)
    @payment_info =     tutor.check_profile_for(:payment_info)

    @check = '<i class="fi-check progress-icon check"></i>' 
    @blank = '<i class="fi-plus progress-icon blank"></i>'
  end
end