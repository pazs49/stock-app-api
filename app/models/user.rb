class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :api, :confirmable
  has_one :user_info, dependent: :destroy

  after_create :create_user_info

  private

  def create_user_info
    UserInfo.create(user_id: self.id, admin: false)
  end

  def after_confirmation
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
