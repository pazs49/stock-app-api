class UserInfoSerializer < ActiveModel::Serializer
  attributes :id, :admin, :balance, :first_name, :last_name, :address, :birthdate
end
