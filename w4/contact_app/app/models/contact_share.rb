class ContactShare < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {:scope => :contact_id}
  validates :contact_id, presence: true

  belongs_to :user
  belongs_to :contact
end
