class RemoveProductFromPurchase < ActiveRecord::Migration[5.1]
  def change
    remove_reference :purchases, :product, foreign_key: true
  end
end
