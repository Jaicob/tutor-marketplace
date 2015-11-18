module OnboardingLinksHelper

  def create_step_blocks(tutor)
    @tutor = tutor

    def step_number_or_check_icon(tutor, link_number)
      @step = tutor.onboarding_status
      case link_number
      when 0
        @step > 0 ? '<i class="fi-check"></i>' : '1'
      when 1
        @step > 1 ? '<i class="fi-check"></i>' : '2'
      when 2
        @step > 2 ? '<i class="fi-check"></i>' : '3'
      when 3
        @step > 3 ? '<i class="fi-check"></i>' : '4'
      end
    end

    def current_step_or_complete_step(tutor, link_number)
      @step = tutor.onboarding_status
      case link_number
      when 0
        if @step == 0
          return 'current-step'
        else
          return 'completed-step'
        end
      when 1
        if @step == 1
          return 'current-step'
        elsif @step > 1
          return 'completed-step'
        end
      when 2
        if @step == 2
          return 'current-step'
        elsif @step > 2
          return 'completed-step'
        end
      when 3
        if @step == 3
          return 'current-step'
        elsif @step > 3
          return 'completed-step'
        end
      end
    end

    def style_links
      @links = {
        "step_one": {
          text: 'Complete your application',
          path: "/tutors/#{@tutor.slug}/onboarding/application",
          circle: step_number_or_check_icon(@tutor, 0),
          classes: current_step_or_complete_step(@tutor, 0)
        },
        "step_two": {
          text: 'Set your courses & rates',
          path: "/tutors/#{@tutor.slug}/onboarding/courses",
          circle: step_number_or_check_icon(@tutor, 1),
          classes: current_step_or_complete_step(@tutor, 1)
        },
        "step_three": {
          text: 'Set your available hours',
          path: "/tutors/#{@tutor.slug}/onboarding/schedule",
          circle: step_number_or_check_icon(@tutor, 2),
          classes: current_step_or_complete_step(@tutor, 2)
        },
        "step_four": {      
          text: 'Set up direct deposit',
          path: "/tutors/#{@tutor.slug}/onboarding/payment_details",
          circle: step_number_or_check_icon(@tutor, 3),
          classes: current_step_or_complete_step(@tutor, 3)
        }
      }
    end

    style_links
    @links
  end

end
