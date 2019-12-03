class RenameItemIdColumnToPurchases < ActiveRecord::Migration[5.1]
  def change
    rename_column :purchases, :item_id, :size_id
  end
end
