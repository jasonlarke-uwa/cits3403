class GeotagInfo < ActiveRecord::Base
	belongs_to :image
	
	attr_accessible :longitude, :latitude, :accuracy
	
	validates :longitude, :presence => true
	validates :latitude, :presence => true
	validates :accuracy, :presence => true
end