require 'pry'
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  after_create :change_host_to_true
  before_destroy :change_host_to_false, if: :users_last_listing?

  def change_host_to_true
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def change_host_to_false
    user = User.find(self.host_id)
    user.host = false
    user.save
  end

  def users_last_listing?
    user = user = User.find(self.host_id)
    if user.listing_ids.count == 1
      true
    else
      false
    end
  end

 def average_review_rating
   reservations = []
   Reservation.all.each do |reservation|
     if reservation.listing_id == self.id
       reservations << reservation
     end
   end

   total_reviews = 0
   reviews = []
   reservations.each do |reservation|
     if reservation.review
       total_reviews += 1
       reviews << reservation.review 
     end
   end

   total_rating = 0.0
   reviews.each do |review|
     total_rating += review.rating
   end

   return total_rating/total_reviews
 end



end
