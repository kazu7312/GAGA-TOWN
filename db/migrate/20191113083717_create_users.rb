class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :postal_code
      t.string :adress

      t.timestamps
    end
  end
end
