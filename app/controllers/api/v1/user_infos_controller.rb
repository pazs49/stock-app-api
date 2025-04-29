class Api::V1::UserInfosController < ApplicationController
  before_action :authenticate_devise_api_token!
  before_action :set_devise_api_token

  def get_user_info
    user = User.find(@devise_api_token.resource_owner_id)
    user_info = user.user_info
    render json: user_info, meta: { email: user_info.user.email }
  end

  private

  def set_devise_api_token
    @devise_api_token = current_devise_api_token
  end
end
