
class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
    @date1 = date1.to_date
    @date2 = date2.to_date
    closed_listing_ids = []
    reservations = Reservation.where(checkin: @date1.beginning_of_day..@date2.end_of_day)
    reservations.each do |reservation|
      closed_listing_ids << reservation.listing_id
    end

    open_listings = []
    self.listings.each do |listing|
      if !closed_listing_ids.include?(listing.id)
        open_listings << listing
      end
    end
    open_listings
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0.0
    highest_res_neighborhood = Neighborhood.new
    Neighborhood.all.each do |neighborhood|
      num_listings = neighborhood.listings.count
      neighborhood_ids = []
      neighborhood_ids << neighborhood.id

      reservations = 0.0
      Reservation.all.each do |reservation|
        listing = Listing.find(reservation.listing_id)
        if neighborhood_ids.include?(listing.neighborhood_id)
          reservations += 1
        end
      end
      ratio = reservations/num_listings
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_res_neighborhood = neighborhood
      end
    end
    highest_res_neighborhood
  end

  def self.most_res
    highest_res = 0
    highest_res_neighborhood = Neighborhood.new
    Neighborhood.all.each do |neighborhood|
      neighborhood_ids = []
      neighborhood_ids << neighborhood.id

      reservations = 0
      Reservation.all.each do |reservation|
        listing = Listing.find(reservation.listing_id)
        if neighborhood_ids.include?(listing.neighborhood_id)
          reservations += 1
        end
      end

      if reservations > highest_res
        highest_res = reservations
        highest_res_neighborhood = neighborhood
      end
    end
    highest_res_neighborhood
  end

end
