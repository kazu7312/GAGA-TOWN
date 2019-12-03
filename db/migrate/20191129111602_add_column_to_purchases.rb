class AddColumnToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :item_id, :integer
  end
end
