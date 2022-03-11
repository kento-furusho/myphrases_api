require "validator/email_validator"

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User
  before_validation :downcase_email
  # 以下独自バリデーション
  validates :name, presence: true,
                   length: {  maximum: 30, allow_blank: true }

  validates :email, email: { allow_blank: true }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: {
                         maximum: 72,
                         minimum: 8,
                         allow_blank: true
                       },
                       format: {
                         with: VALID_PASSWORD_REGEX,
                         message: :invalid_password,
                         allow_blank: true
                       },
                       allow_blank: true
  private
  def downcase_email
    self.email.downcase! if email
  end
end
