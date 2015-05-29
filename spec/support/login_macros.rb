module LoginMacros

  def sign_in(user)
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

end