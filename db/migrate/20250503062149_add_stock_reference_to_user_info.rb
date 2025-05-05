class AddStockReferenceToUserInfo < ActiveRecord::Migration[8.0]
  def change
    add_reference :user_infos, :stock, foreign_key: true
  end
end
