class AddImageUrlToCat < ActiveRecord::Migration
  def change
    add_column :cats, :image_url, :string, null: false, default: 'https://d1luk0418egahw.cloudfront.net/static/images/guide/NoImage_592x444.jpg'
  end
end
