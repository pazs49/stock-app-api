class AddNameToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :name, :string
  end
end
