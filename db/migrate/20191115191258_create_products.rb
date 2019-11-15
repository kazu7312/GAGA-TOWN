class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.references :brand, foreign_key: true
      t.integer :price
      t.text :detail
      t.string :icon

      t.timestamps
    end
    add_index :products, [:brand_id, :name]
    add_index :products, [:category_id, :name]
    add_index :products, :price
    add_index :products, :created_at
  end
end