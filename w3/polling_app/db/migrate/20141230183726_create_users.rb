class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, uniqueness: true, presence: true

      t.timestamps null: false
    end
  end
end
