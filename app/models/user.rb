class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :recoverable, :rememberable, :trackable
  devise :database_authenticatable, :registerable, :validatable

  has_many :meals, dependent: :destroy, inverse_of: :user
  before_create :ensure_auth_token

  def ensure_auth_token
    if auth_token.blank?
      self.auth_token = generate_auth_token
    end
  end

  private

    def generate_auth_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(auth_token: token).first
      end 
    end

end
