class ExistingTutorOnboarding

  def initialize(email, password)
    @email = email
    @password = password
  end

  def create_user_and_tutor
    if existing_tutor?
      user = User.create(
        email: @email,
        password: @password,
        first_name: tutor_email_list.first[@email][:first],
        last_name: tutor_email_list.first[@email][:last]
      )
      if user.save
        tutor = user.create_tutor!(
          phone_number: params[:user][:tutor][:phone_number],
          school_id: params[:user][:tutor][:school_id]
        )
        # send SPECIAL EXISTING TUTOR welcome email
        # TODO - create special welcome email for these tutors
        TutorManagementMailer.delay.existing_tutor_welcome_email(user.id)
        response = {
          success: true,
          tutor: tutor
        }
      else
        response = {
          success: false,
          error: user.errors.full_messages.first
        }
      end
    else
      response = {
        success: false,
        error: 'Email not registered.'
      }
    end
    return response
  end

  def existing_tutor?
    if tutor_email_list[0].keys.include?(@email)
      true
    else
      false
    end
  end

  def tutor_email_list
    [
      'jtjobe@gmail.com' => {
        first: 'JT',
        last: 'Jobe'
      },
      'bob123@unc.edu' => {
        first: 'Bob',
        last: 'Ross'
      },
      'rick@hotmail.com'=> {
        first: 'Ricky',
        last: 'Bobby'
      }
    ]
  end
end