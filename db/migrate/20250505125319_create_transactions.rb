class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :action
      t.datetime :date
      t.decimal :price
      t.decimal :qty
      t.references :user_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
