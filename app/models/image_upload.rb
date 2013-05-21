require 'rubygems'
require 'rmagick'

class ImageUpload
	include ActiveModel::Validations
	
	SMALL_IMAGE = [128, 128]
	MEDIUM_IMAGE = [400, 400]
	LARGE_IMAGE = [1024, 1024]
	
	attr_accessor :upload
	attr_accessor :use_geo
	attr_accessor :directory
	attr_accessor :uniqid
	attr_accessor :info
	
	validates_presence_of :image, :use_geo, :directory
	
	def initialize(attributes = {})
		@attributes = attributes
	
		@upload = attributes[:image] || nil
		@use_geo = attributes[:use_geo] || nil
		@directory = attributes[:directory] || nil
		@info = { :width => nil, :height => nil, :mime => @upload.nil? ? nil : @upload.content_type }
	end

	def read_attribute_for_validation(key)
		@attributes[key]
	end
	
	def save
		@uniqid = generate_uuid()
		path = get_path
		
		begin
			tmp = @upload.tempfile
			FileUtils.cp tmp.path, path
			# todo: Get build_thumbnails working
			# build_thumbnails
			return true
		rescue => e
			puts e.message
			puts e.backtrace.join("\n")
			@errors.add(:upload, "Error uploading the image to the server, please try again")
			return false
		end
	end
	
	def destroy
		raise Exception::StandardError.new('Cannot call destroy before calling save') if @uniqid.blank?
		
		begin
			File.delete(get_path)
		rescue
		end
	end

	# helpers
	protected
	# Generate a new UUID for new records only
	def generate_uuid
		ext = File.extname(@upload.original_filename)
		loop do
			# in hex(n), n actually specifies 1/2 of the resultant length so use 8 to fill 16 chars
			rand_tok = SecureRandom.hex(8)
			break rand_tok unless File.exists?(File.join(@directory, rand_tok + ext)) || Image.where(:uniqid => rand_tok).exists?
		end
	end
	
	def get_path(size='')
		size = "_#{size}" unless size.blank?
		return File.join(@directory, "#{@uniqid}#{size}#{File.extname(@upload.original_filename)}")
	end
	
	def build_thumbnails
		# Called once the uuid has been assigned. Use an image library to resize the original image using get_path()
		# and save them in a predefined naming convention of <uuid>_<small|medium|large>.<extension>
		begin
			thumb = MiniMagick::Image.open(get_path)
			thumb.resize(SMALL_IMAGE.join('x'))
			thumb.write(get_path('small'))
		rescue MiniMagick::Invalid => e
			puts "MINIMAGIC!::: #{e.inspect}"
		end
	end
end