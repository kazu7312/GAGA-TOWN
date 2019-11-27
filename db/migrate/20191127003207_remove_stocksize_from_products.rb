class RemoveStocksizeFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :products, :size, foreign_key: true
    remove_column :products, :stock, :integer
  end
end
