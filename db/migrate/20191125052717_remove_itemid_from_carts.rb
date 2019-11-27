class RemoveItemidFromCarts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :carts, :item, foreign_key: true
  end
end
