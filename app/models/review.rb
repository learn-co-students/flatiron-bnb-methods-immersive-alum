class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true

  validate :reservation_accepted
  validate :reservation_ended

  private

  def reservation_accepted
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "Reservation is must be accepted")
    end
  end

  def reservation_ended
    if reservation && reservation.checkout.to_date > Date.today
      errors.add(:checkout, "Please checkout to leave a review")
    end
  end

end
