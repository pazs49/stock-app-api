class AddNameToUserInfos < ActiveRecord::Migration[8.0]
  def change
    add_column :user_infos, :name, :string
  end
end
