class Addlocation < ActiveRecord::Migration
  def change
    add_column :session_tokens, :latitude, :string
    add_column :session_tokens, :longitude, :string
  end
end
