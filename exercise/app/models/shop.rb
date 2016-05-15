class Shop < ActiveRecord::Base
	geocoded_by :latitude => :latitude, :longitude => :longitude
	
	#Listing all constraints
	validates :chain,
		presence: true, length: {minimum: 3}
	validates :name,
		presence: true, length: {minimum: 5, maximum: 50}
	validates :latitude,
		presence: true, numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
	validates :longitude,
		presence: true, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}
	validates :address,
		presence: true
	validates :city,
		presence: true, length: {minimum: 2}
	validates :zip,
		presence: true, numericality: {greater_than_or_equal_to: 1000, less_than: 100000, only_integer: true}
	validates :phone,
		presence: true, length: {is: 10}, uniqueness: true
	validates :country_code,
		presence: true
end
