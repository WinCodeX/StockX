class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :username, presence: true, uniqueness: true
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
       jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

has_one_attached :avatar
has_many :user_businesses
has_many :businesses, through: :user_businesses

end
