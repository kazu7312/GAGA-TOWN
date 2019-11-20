class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :postal_code
      t.string :address

      t.timestamps
    end
    add_index :users, :email
  end
end
