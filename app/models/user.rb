class User < ActiveRecord::Base
  has_secure_password
  has_many :articles

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PASS = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/

  validates :email, format: {
      with: VALID_EMAIL,
      message: 'Invalid email format. Format example "example@example.com"'}
  validates :password, format: {
      with: VALID_PASS,
      message: 'Password should contain a number, uppercase letter and lowercase letter'}
end