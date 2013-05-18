class PrivacyLevel < ActiveRecord::Base
	attr_accessible :hint, :display
	
	validates :hint, :presence => true, :length => { :maximum => 16 }
end