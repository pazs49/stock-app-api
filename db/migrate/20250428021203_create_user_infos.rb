class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
