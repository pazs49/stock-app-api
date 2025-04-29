class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :confirmed_at, :user_info
end
