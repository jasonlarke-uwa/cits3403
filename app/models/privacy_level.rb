class PrivacyLevel < ActiveRecord::Base
	attr_accessible :hint;
	validates :hint, :limit => { :maximum => 16 }
end