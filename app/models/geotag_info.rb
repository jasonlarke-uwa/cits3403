class GeotagInfo < ActiveRecord::Base
	belongs_to :image
	
	attr_accessible :longitude, :latitude, :accuracy
end