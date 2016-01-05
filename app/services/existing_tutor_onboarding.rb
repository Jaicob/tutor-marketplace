class ExistingTutorOnboarding
  require 'csv'

  # x = ExistingTutorOnboarding.new('jtjobe@gmail.com', 'password')
  # ExistingTutorOnboarding.new('jtjobe@gmail.com', 'password').create_user_and_tutor
  
  # x = ExistingTutorOnboarding.new('claire.france25@uga.edu', 'password')
  # ExistingTutorOnboarding.new('claire.france25@uga.edu', 'password').create_user_and_tutor

  def initialize(email, password)
    @email = email
    @password = password
  end

  def create_user_and_tutor
    if existing_tutor?
      user = User.create(
        email: @email,
        password: @password,
        first_name: @tutors_by_email[@email][:first_name],
        last_name: @tutors_by_email[@email][:last_name]
      )
      if user.save
        tutor = user.create_tutor!
        ExistingTutorMailer.delay.welcome_email(user.id)
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
    if tutors_by_email.has_key?(@email)
      true
    else
      false
    end
  end

  def tutors_by_email
    @tutors = CSV.read('lib/assets/existing-tutors-for-onboarding.csv')
    # each tutor is represented by an array of info: [full_name, first_name, last_name, email]
    @tutors_by_email = {}

    @tutors.each do |tutor_info|
      @tutors_by_email[tutor_info[3]] = {
        first_name: tutor_info[1],
        last_name: tutor_info[2]
      }
    end
    return @tutors_by_email
  end

end