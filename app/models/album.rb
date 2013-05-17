class Album < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
	has_one :privacy_level;
	has_many :images;
	
	attr_accessible :title, :description
	
	validates :title, :length => { :maximum => 64 }
	validates :description, :length => { :maximum => 512 }
end