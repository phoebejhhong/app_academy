# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  short_url    :string
#  long_url     :text
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: :true
  validates :long_url, presence: :true
  validates :submitter_id, presence: :true

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor
  )

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many(
    :tags,
    through: :taggings,
    source: :topic
  )

  def self.random_code
    loop do
      shortened_url = SecureRandom::urlsafe_base64
      return shortened_url unless self.exists?(short_url: shortened_url)
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(submitter_id: user.id,
          long_url: long_url, short_url: ShortenedUrl.random_code)
  end

  def num_clicks
    Visit.where(url_id: self.id).count
  end

  def num_uniques
    # Visit.select(:visitor_id).where(url_id: self.id).distinct
    # next line works after adding "-> { distinct }" to has_many assoc. above
    self.visitors.count
  end

  def num_recent_uniques
    # Visit.select(:visitor_id).where(["created_at >= ? AND url_id = ?", 10.minutes.ago, self.id])
    #   .distinct.count
    self.visitors.where("visits.created_at >= ?", 10.minutes.ago).count
  end

end
