class ExistingTutorOnboarding

  def initialize(email)
    @email = email
  end

  def existing_tutor?
    if tutor_email_list.first.keys.include?(@email)
      response = {
        success: true,
        email: @email,
        first: tutor_email_list.first[@email][:first],
        last: tutor_email_list.first[@email][:last],
      }
    else
      response = {
        success: false,
        error: 'Email not registered.'
      }
    end
    return response
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