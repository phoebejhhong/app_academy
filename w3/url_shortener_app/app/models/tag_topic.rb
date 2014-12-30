class TagTopic < ActiveRecord::Base

  validates :name, presence: :true

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :topic_id,
    primary_key: :id
  )

  has_many(
    :urls,
    through: :taggings,
    source: :url
  )

  def most_popular_url
    url_count = Hash.new(0)
    self.urls.each do |url|
      url_count[url] = url.num_clicks
    end
    url_count.keys.max_by{ |url| url_count[url] }
  end

end
