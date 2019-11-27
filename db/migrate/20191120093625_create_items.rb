class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :product, foreign_key: true
      t.references :size, foreign_key: true
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
