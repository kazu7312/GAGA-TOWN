class AddCulumnsToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :product_name, :string
    add_column :purchases, :category_name, :string
    add_column :purchases, :brand_name, :string
    add_column :purchases, :price, :integer
    add_column :purchases, :detail, :text
    add_column :purchases, :icon, :integer
  end
end
