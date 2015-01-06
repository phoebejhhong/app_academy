class Grouping < ActiveRecord::Base
  validates :group_id, :contact_id, presence: true

  belongs_to :contact_group, foreign_key: :group_id
  belongs_to :contact
end
