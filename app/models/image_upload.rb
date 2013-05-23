#require 'rubygems'
#require 'rmagick'

class ImageUpload
	include ActiveModel::Validations
	include MiniMagickHelper

	ALLOWED_TYPES = ['image/jpeg','image/png','image/tiff','image/gif','image/x-icon','image/pjpeg','image/x-tiff']

	PREVIEW_SIZE = [178,178]
	
	IMAGE_SIZES = {
		:small => [128, 128], 
		:medium => [400, 400],
		:large => [1024, 1024]
	} 

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
		@info = { 
			:width => nil, 
			:height => nil,
			:mime => @upload.nil? ? nil : @upload.content_type, 
			:ext => @upload.nil? ? nil : File.extname(@upload.original_filename)
		}
	end

	def read_attribute_for_validation(key)
		@attributes[key]
	end
	
	def save
		@uniqid = generate_uuid()
		path = get_path

		if @upload.nil?
			@errors.add(:upload, "Error uploading the image to the server, please try again")
			return false	
		elsif !ALLOWED_TYPES.include?(@info[:mime])
			@errors.add(:upload, "Invalid file format uploaded to the server")
			return false
		end
		
		begin
			tmp = @upload.tempfile
			FileUtils.cp(tmp.path, path)
			build_thumbnails
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
		
		paths = IMAGE_SIZES.keys.map{|k| get_path(k)}
		paths << get_path('preview')
		paths << get_path()
 
		begin
			File.delete(*paths)
		rescue
		end
	end

	# helpers
	protected
	# Generate a new UUID for new records only
	def generate_uuid
		loop do
			# in hex(n), n actually specifies 1/2 of the resultant length so use 8 to fill 16 chars
			rand_tok = SecureRandom.hex(8)
			break rand_tok unless File.exists?(File.join(@directory, "#{rand_tok}#{@info[:ext]}")) || Image.where(:uniqid => rand_tok).exists?
		end
	end
	
	def get_path(size='')
		size = "_#{size}" unless size.blank?
		return File.join(@directory, "#{@uniqid}#{size}#{@info[:ext]}")
	end
	
	def build_thumbnails
		# Called once the uuid has been assigned. Use an image library to resize the original image using get_path()
		# and save them in a predefined naming convention of <uuid>_<small|medium|large>.<extension>
		
		# build the fixed size "preview" icon
		img = MiniMagick::Image.open(get_path)
		resize_and_crop_image(img, PREVIEW_SIZE)
		img.write(get_path('preview'))

		begin
			IMAGE_SIZES.each do |size,dimensions|
				puts "DEBUG::::path(#{get_path})"
				puts "DEBUG::::outp(#{get_path(size.to_s)})"
				img = MiniMagick::Image.open(get_path)
				img.resize(dimensions.join('x'))
				img.write(get_path(size.to_s))
			end
		rescue MiniMagick::Invalid => e
			puts "MINIMAGIC!::: #{e.inspect}"
		end
	end
end
