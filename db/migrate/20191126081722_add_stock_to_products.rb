class AddStockToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :stock, :integer, null: false, default: 0
  end
end
