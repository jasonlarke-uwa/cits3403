module ApplicationHelper
	def title(page_title)
		content_for(:title) { page_title }
	end

	def get_image_url(image, size=nil)
		public_dir = File.join(Rails.root, 'public')

		size = "_#{size}" unless size.nil?
		dir = Cits3403::Application.config.upload_directory
		filename = image.nil? ? 'blank_preview.png' : "#{image.uniqid}#{size}#{image.extension}"
		filename = File.join('/', dir, filename)

		filename = File.join('/', dir, "#{image.uniqid}#{image.extension}") unless (image.nil? || File.exists?(File.join(public_dir, filename))) 
		return filename
	end

	def is_current_page(path) 
		return request.fullpath == path
	end	

	def conditional_output(cond, html)
		return (cond ? html : '').html_safe
	end

	def image_breadcrumb(image)
		return "" if image.nil?

		album = image.album
		owner = album.owner

		crumbs = [ 
			link_to("Home", root_path),
			link_to("#{owner.first_name} #{owner.last_name}", albums_user_path(owner)),
			link_to(album.title, album_path(album))
		]

		create_breadcrumb(crumbs)
	end

	def album_breadcrumb(album)
		return "" if album.nil?

		owner = album.owner
		crumbs = [
			link_to("Home", root_path),
			link_to("#{owner.first_name} #{owner.last_name}", albums_user_path(owner)),
			"#{album.title}"
		]
		create_breadcrumb(crumbs)
	end

protected
	def create_breadcrumb(crumbs)
		separator = "&nbsp;&gt;&gt;&nbsp;"
		content = crumbs.join(separator).html_safe

		content_tag(:div, content, :class => "breadcrumb fullwidth") + content_tag(:div, '', :class => "clearing")
	end
end
