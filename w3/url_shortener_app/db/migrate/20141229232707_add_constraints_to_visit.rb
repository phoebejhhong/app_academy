class AddConstraintsToVisit < ActiveRecord::Migration
  def change
    change_column :visits, :visitor_id, :integer, null: :false
    change_column :visits, :url_id, :integer, null: :false

  end
end
