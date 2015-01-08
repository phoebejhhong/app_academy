class AddUserid < ActiveRecord::Migration
  def change
    add_reference :cats, :owner, index: true
    change_column :cats, :owner_id, :integer, null: false, default: 1
  end
end
