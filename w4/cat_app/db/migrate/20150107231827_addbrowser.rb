class Addbrowser < ActiveRecord::Migration
  def change
    add_column :session_tokens, :browser_info, :string
  end
end
