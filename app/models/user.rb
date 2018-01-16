require 'pry'
class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = []
    reservations.each do |reservation|
      guest = User.find_by_id(reservation.guest_id)
      guests << guest
    end
    guests
  end

  def hosts
    hosts = []
    trips.each do |trip|
      listing = Listing.find_by_id(trip.listing_id)
      host = User.find_by_id(listing.host_id)
      hosts << host
    end
    hosts
  end

  def host_reviews
    reviews = []
    reservations.each do |reservation|
      review = reservation.review
      reviews << review
    end
    reviews
  end

end
