class RemoveItemidFromPurchases < ActiveRecord::Migration[5.1]
  def change
    remove_reference :purchases, :item, foreign_key: true
  end
end
