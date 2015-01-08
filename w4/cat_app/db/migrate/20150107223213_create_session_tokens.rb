class CreateSessionTokens < ActiveRecord::Migration
  def change
    create_table :session_tokens do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false

      t.timestamps null: false
    end

    remove_column :users, :session_token
  end
end
