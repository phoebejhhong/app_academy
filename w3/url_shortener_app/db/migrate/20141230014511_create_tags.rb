class CreateTags < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :url_id, null: :false
      t.integer :topic_id, null: :false

      t.timestamps
    end

    create_table :tag_topics do |t|
      t.string :name, null: :false

      t.timestamps
    end

    add_index(:taggings, :url_id)
    add_index(:taggings, :topic_id)
    add_index(:tag_topics, :name)
  end
end
