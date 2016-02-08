module OnboardingApplicationHelper
  
  def application_section_status(section)
    if section == 'education'
      "<div class='application-section-status'>
          <p class='no-bottom-margin'><i class='fi-minus-circle'></i>Section not saved</p>
      </div>"
    else
      "<div class='application-section-status'>
          <p class='no-bottom-margin'><i class='fi-checkbox'></i>Section saved</p>
      </div>"
    end
  end

end