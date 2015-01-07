class Cat < ActiveRecord::Base
  COLORS = ["brown", "white", "black", "yellow", "grey", "blue", "rainbow"]
  validates :birth_date, :name, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is invalid" }
  validates :sex, inclusion: { in: %w(M F), message: "%{value} is invalid" }

  has_many(
    :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id
  )

  def age
    # Use SQL to do this later
    Integer((Time.now - birth_date.to_time) / 31536000)
  end
  
end
