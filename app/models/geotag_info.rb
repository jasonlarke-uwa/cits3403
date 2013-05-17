class GeotagInfo < ActiveRecord::Base
	belongs_to :image
	
	attr_readonly :longitude, :latitude, :accuracy
end