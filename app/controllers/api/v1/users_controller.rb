class Api::V1::UsersController < ApplicationController
  before_action :authenticate_devise_api_token!
  before_action :set_devise_api_token

  def index
    user = User.find(@devise_api_token.resource_owner_id)
    if (user.user_info.admin)
      @users = User.joins(:user_info).where(user_infos: { admin: false })
      render json: @users, include: ["user_info"]
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  #admin
  def admin_create_user
    permitted_params = params.require(:user).permit(:email, :password)
    current_user = User.find(@devise_api_token.resource_owner_id)
    if (current_user.user_info.admin)
      user = User.create(permitted_params.merge(confirmed_at: Time.current))
      if (user.persisted?)
        render json: user, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def admin_approve_user
    current_user = User.find(@devise_api_token.resource_owner_id)
    if (current_user.user_info.admin)
      user = User.find(params[:id])
      user.update(confirmed_at: Time.current)
      render json: user, status: :ok
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def set_devise_api_token
    @devise_api_token = current_devise_api_token
  end
end
