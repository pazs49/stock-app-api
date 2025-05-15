class Api::V1::UserInfosController < ApplicationController
  before_action :authenticate_devise_api_token!
  before_action :set_devise_api_token
  before_action :set_user, only: [:get_user_info, :get_user_transactions, :get_user_transactions_admin, :edit_user_info_admin, :get_user_info_admin, :edit_user_info, :user_deposit]

  def get_user_info
    render json: @user.user_info, meta: { email: @user.email }
  end

  def get_user_transactions
    render json: @user.user_info.transactions
  end

  def get_user_transactions_admin
    if (@user.user_info.admin)
      transactions = Transaction.all
      render json: transactions
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def edit_user_info
    user_info = @user.user_info.update(user_info_params_user)
    if (user_info)
      render json: user_info, status: :ok
    else
      render json: { error: user_info.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_deposit
    user = User.find(@devise_api_token.resource_owner_id)
    new_balance = user.user_info.balance + params[:amount].to_f

    if user.user_info.update(balance: new_balance)
      render json: user.user_info, status: :ok
    else
      render json: { error: user.user_info.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit_user_info_admin
    if (@user.user_info.admin)
      user = User.find(params[:id])
      user.user_info.update(user_info_params)
      render json: user.user_info
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def get_user_info_admin
    if @user.user_info.admin
      target_user = User.find(params[:id])
      render json: target_user.user_info, meta: { email: target_user.email, transactions: target_user.user_info.transactions }
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def set_devise_api_token
    @devise_api_token = current_devise_api_token
  end

  def set_user
    @user = User.find(@devise_api_token.resource_owner_id)
  end

  def user_info_params_user
    params.require(:user_info).permit(:first_name, :last_name, :address, :birthdate)
  end

  def user_info_params
    params.require(:user_info).permit(:admin, :first_name, :last_name, :address, :birthdate)
  end
end
