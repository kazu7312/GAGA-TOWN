class CreateSizes < ActiveRecord::Migration[5.1]
  def change
    create_table :sizes do |t|
      t.string :name
    end
    add_index :sizes, :name
  end
end
