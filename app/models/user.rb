class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :assignments, dependent: :delete_all
  has_many :customers, through: :assignments 
  devise :database_authenticatable, :registerable,      
         :recoverable, :rememberable, :validatable, password_length: 8..25
  validate :password_complexity
  validates :email, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true, case_sensitive: false
  

  def password_complexity
    if password.present? and not password.match(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,25}$/)
      errors.add :password, "must be at least 8 characters long and include 1 uppercase, 1 number, and 1 special character."
    end
  end
end
