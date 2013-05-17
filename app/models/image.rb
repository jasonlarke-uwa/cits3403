class Image < ActiveRecord::Base
	belongs_to :album
	has_one :geotag_info
	
	attr_accessible :caption
	attr_readonly :uniqid, :width, :height, :mime
	
	validates :caption, :length => { :maximum => 256 }
	validates :mime, :length { :maximum => 16 }
	
	before_create :generate_uuid
	
	# helpers
	protected
	# Generate a new UUID for new records only
	def generate_uuid
		self.uniqid = loop do
			# in hex(n), n actually specifies 1/2 of the resultant length so use 8 to fill 16 chars
			rand_tok = SecureRandom.hex(8)
			break rand_tok unless Image.where(:uniqid => rand_tok).exists?
		end
	end
end