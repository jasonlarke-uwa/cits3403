module DeviseHelper
	def devise_error_messages!(warning)
		return "" if (resource.errors.nil? || resource.errors.empty?)

		html = content_tag(:strong, warning, :class => "c2")
		items = resource.errors.full_messages.map { |e| content_tag(:li, e) }.join
		html << content_tag(:ul, items.html_safe, :class => "form-errors")

		return html.html_safe
	end
end
