require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_host
  validate :end_date_is_after_start_date
  validate :dates_not_the_same
  validate :available

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:checkin, "Sorry, this listing is not available during these dates.")
      end
    end
  end

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest, "host cannot book their own listing")
    end
  end

  def end_date_is_after_start_date
    if checkin && checkout
      if self.checkin.to_date > self.checkout.to_date
        errors.add(:checkin, "check-in must be before check-out")
      end
    end

    def dates_not_the_same
      if checkin && checkout
        if self.checkin == self.checkout
          errors.add(:checkin, "check-in and check-out cannot be the same")
        end
      end
    end
  end

  def duration
    duration = checkout.to_date - checkin.to_date
  end

  def total_price
    duration*self.listing.price
  end


end
