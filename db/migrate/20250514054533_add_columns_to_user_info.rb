class AddColumnsToUserInfo < ActiveRecord::Migration[8.0]
  def change
    add_column :user_infos, :first_name, :string
    add_column :user_infos, :last_name, :string
    add_column :user_infos, :birthdate, :date
    add_column :user_infos, :address, :text
  end
end
