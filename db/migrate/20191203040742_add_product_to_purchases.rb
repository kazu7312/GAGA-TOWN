class AddProductToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :product_id, :integer
  end
end
