class Addrequester < ActiveRecord::Migration
  def change
    add_reference :cat_rental_requests, :requester, index: true
    change_column :cat_rental_requests, :requester_id, :integer, null: false
  end
end
