class AddFavoritesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :favorite, :boolean, null: false, default: false
    add_column :contact_shares, :favorite, :boolean, null: false, default: false
  end
end
