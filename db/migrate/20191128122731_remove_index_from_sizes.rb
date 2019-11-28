class RemoveIndexFromSizes < ActiveRecord::Migration[5.1]
  def change
    remove_index :sizes, :name
  end
end
