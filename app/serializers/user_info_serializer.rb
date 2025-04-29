class UserInfoSerializer < ActiveModel::Serializer
  attributes :id, :admin, :balance
end
