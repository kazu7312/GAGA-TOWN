class AddIndexToFavorite < ActiveRecord::Migration[5.1]
  def change
    add_index :favorites, [:user_id, :product_id], unique: true
  end
end
