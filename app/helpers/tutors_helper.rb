module TutorsHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def tutor_blurb(tutor)
    if tutor.appt_notes
      tutor.appt_notes
    end
  end
  
end