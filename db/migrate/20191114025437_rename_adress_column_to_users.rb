class RenameAdressColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :adress, :address
  end
end
