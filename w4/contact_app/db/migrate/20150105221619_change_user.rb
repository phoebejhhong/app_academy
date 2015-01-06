class ChangeUser < ActiveRecord::Migration
  def change
    remove_column :users, :name, :string
    remove_column :users, :email, :string
    add_column :users, :username, :string, null: false, default: "no name", unique: true
  end
end
