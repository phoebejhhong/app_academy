class Editlatlong < ActiveRecord::Migration
  def change
    remove_column :session_tokens, :latitude
    remove_column :session_tokens, :longitude
    add_column :session_tokens, :latitude, :float
    add_column :session_tokens, :longitude, :float
  end
end
