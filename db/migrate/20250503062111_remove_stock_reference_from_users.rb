class RemoveStockReferenceFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_reference :users, :stock, foreign_key: true
  end
end
