# Preview all emails at http://localhost:3000/rails/mailers/existing_tutor_management
class ExistingTutorManagementPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/existing_tutor_management/welcome
  def welcome
    ExistingTutorManagement.welcome
  end

  # Preview this email at http://localhost:3000/rails/mailers/existing_tutor_management/activation
  def activation
    ExistingTutorManagement.activation
  end

end
