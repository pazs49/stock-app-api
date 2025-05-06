class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :name, :action, :date, :price, :qty, :user_info, :email

  def email
    object.user_info.user.email
  end
end
