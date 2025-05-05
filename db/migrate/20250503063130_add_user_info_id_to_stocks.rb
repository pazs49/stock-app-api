class AddUserInfoIdToStocks < ActiveRecord::Migration[8.0]
  def change
    add_reference :stocks, :user_info, foreign_key: true
  end
end
