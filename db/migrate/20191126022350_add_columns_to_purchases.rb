class AddColumnsToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_reference :purchases, :product, foreign_key: true
    add_column :purchases, :total, :integer
  end
end
