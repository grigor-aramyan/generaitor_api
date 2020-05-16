class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :accountable, polymorphic: true
  has_many :messages
  has_many :feedbacks

  def jwt_payload
    super.merge(user_id: self.id)
  end
end
