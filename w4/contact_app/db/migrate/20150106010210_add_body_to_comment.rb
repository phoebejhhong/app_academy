class AddBodyToComment < ActiveRecord::Migration
  def change
    add_column :comments, :body, :text, null: false, default: "comment"
  end
end
