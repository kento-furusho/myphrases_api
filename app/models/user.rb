# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User
  # 以下独自バリデーション
  validates :name, presence: true,
                   length: {  maximum: 30, allow_blank: true }
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: { minimum: 8 },
                       format: {
                         with: VALID_PASSWORD_REGEX,
                         message: :invalid_password
                       },
                       allow_nil: true
end
