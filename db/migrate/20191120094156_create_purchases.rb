class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.string :destination_name
      t.string :destination_address
      t.string :destination_postal_code
      t.string :credit_number

      t.timestamps
    end
    add_index :purchases, :created_at
  end
end
