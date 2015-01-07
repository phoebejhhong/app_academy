class CatRentalRequest < ActiveRecord::Base
  after_initialize :set_default_status
  STATUSES = ["APPROVED", "DENIED", "PENDING"]
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES, message: "%{value} is invalid" }
  validate :no_overlapping_approved_request, :date_validation, :start_date_validate, on: :create

  belongs_to :cat, dependent: :destroy

  def approve!
    if overlapping_approved_requests.empty?
      ActiveRecord::Base.transaction do
        self.update!(status: "APPROVED")
        overlapping_pending_requests.each do |req|
          req.deny!
        end
      end
    else
      self.deny!
    end
  end

  def deny!
    self.update!(status: "DENIED")
  end

  def pending?
    status == "PENDING"
  end

  private
    def set_default_status
      self.status ||= "PENDING"
    end
    def overlapping_requests
      where_query = <<-SQL
        (cat_rental_requests.start_date - :second_end_date) * (:second_start_date - cat_rental_requests.end_date) >= 0 AND
        cat_rental_requests.cat_id = :cat_id
      SQL
      CatRentalRequest.where(where_query, {second_end_date: end_date, second_start_date: start_date, cat_id: cat_id})
    end

    def overlapping_approved_requests
      overlapping_requests.where("status = 'APPROVED'")
    end

    def overlapping_pending_requests
      overlapping_requests.where("status = 'PENDING'")
    end

    def no_overlapping_approved_request
      unless overlapping_approved_requests.empty?
        errors[:overlap] << "already taken!"
      end
    end

    def date_validation
      if (end_date && start_date) && end_date < start_date
        errors[:date_conflict] << "start date should be earlier than end date"
      end
    end

    def start_date_validate
      errors[:date_conflict] << "needs to request 1 week in advance" if 1.week.from_now > start_date
    end
end
