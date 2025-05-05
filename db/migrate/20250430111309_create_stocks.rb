class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.decimal :price
      t.integer :qty

      t.timestamps
    end
  end
end
