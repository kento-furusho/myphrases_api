class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: users.as_json(only: [:id, :name, :email, :created_at])
  end
  def show
    @user = User.find(params[:id])
    render json: @user.as_json(only: [:id, :name, :email, :created_at])
  # def create
  #   current_api_v1_user
  #   # @user = current_api_v1_user
  #   # render json: @user.as_json(only: [:id, :name, :email, :created_at])
  #   # user = User.find(params[:id])
  #   # render json: user.as_json(only: [:id, :name, :email, :created_at])
  # end
  end
end
