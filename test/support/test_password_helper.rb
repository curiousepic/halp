require "bcrypt"

module TestPasswordHelper
  def password_digest(password = default_password)
    BCrypt::Password.create(password, cost: 4)
  end

  def default_password
    "password"
  end
end