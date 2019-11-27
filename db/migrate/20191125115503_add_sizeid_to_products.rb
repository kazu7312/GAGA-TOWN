class AddSizeidToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :size, foreign_key: true
  end
end
