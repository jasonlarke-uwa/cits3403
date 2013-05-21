class Image < ActiveRecord::Base
	belongs_to :album
	has_one :geotag_info
	
	attr_accessible :caption
	attr_protected :uniqid, :width, :height, :mime
	
	validates :caption, :length => { :maximum => 256 }
	validates :mime, :length => { :maximum => 16 }
end