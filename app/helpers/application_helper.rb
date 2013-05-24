module ApplicationHelper
	def title(page_title)
		content_for(:title) { page_title }
	end

	def get_image_url(image, size=nil)
		size = "_#{size}" unless size.nil?
		dir = Cits3403::Application.config.upload_directory
		filename = image.nil? ? 'blank_preview.png' : "#{image.uniqid}#{size}#{image.extension}"
		return File.join('/', dir, filename)
	end
end
