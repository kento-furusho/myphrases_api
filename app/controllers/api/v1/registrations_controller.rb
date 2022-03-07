class Api::V1::RegistrationsController < ApplicationController
  private
    def sign_up_params
      params.require(:registration).permit(:name, :email, :password, :password_confirmation)
    end
end
