class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :product, foreign_key: true
      t.references :size, foreign_key: true
      t.integer :stock, null: false, default: 0

      t.timestamps
    end
  end
end
