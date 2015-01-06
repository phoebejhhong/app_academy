class CreateContactGroups < ActiveRecord::Migration
  def change
    create_table :contact_groups do |t|
      t.string :name, null: false
      t.integer :owner_id, null: false

      t.timestamps null: false
    end

    create_table :groupings do |t|
      t.integer :group_id, null: false
      t.integer :contact_id, null: false

      t.timestamps null: false
    end
  end
end
