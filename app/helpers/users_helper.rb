module UsersHelper

  def public_name(role)
    role.user.first_name.capitalize + " " + role.user.last_name.capitalize.slice(0) + "."
  end

end