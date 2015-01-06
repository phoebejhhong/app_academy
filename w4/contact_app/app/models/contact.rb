class Contact < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {:scope => :email}
  validates :name, :email, presence: true

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :shares, class_name: 'ContactShare', dependent: :destroy
  has_many :comments, :as => :commentable
end
