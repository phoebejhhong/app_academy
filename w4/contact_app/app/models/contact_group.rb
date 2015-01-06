class ContactGroup < ActiveRecord::Base
  validates :name, :owner_id, presence: true

  belongs_to :owner, class_name: 'User'
  has_many :groupings, foreign_key: :group_id
  has_many :contacts, through: :groupings
end
