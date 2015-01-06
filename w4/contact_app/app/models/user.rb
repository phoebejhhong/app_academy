class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many :contacts, dependent: :destroy
  has_many :contact_shares
  has_many :shared_contacts, through: :contact_shares, source: :contact
  has_many :comments, :as => :commentable
  has_many :contact_groups, foreign_key: :owner_id

end
