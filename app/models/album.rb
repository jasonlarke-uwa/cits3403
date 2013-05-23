class Album < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
	belongs_to :privacy_level;
	has_many :images;
	
	attr_accessible :title, :description, :privacy_level_id
	
	validates :title, :presence => true, :length => { :maximum => 64 }
	validates :description, :presence => true, :length => { :maximum => 512 }
	validates :privacy_level, :presence => true
	validates :owner, :presence => true
end