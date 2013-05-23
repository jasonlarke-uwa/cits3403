module MiniMagickHelper
  GRAVITY_TYPES = [ :north_west, :north, :north_east, :east, :south_east, :south, :south_west, :west, :center ]
 
  def resize_and_crop_image(img, size, options = {})
    gravity = options[:gravity] || :center
    width, height = size
    #img.opaque
 
    img_width, img_height = *(img[:dimensions].map { |d| d.to_f } )
    resize_string = ''
 
    # Resize image to minimize difference between actual dimension and target dimension
    if img_width / width < img_height / height
      resize_string = "#{width.to_i}x"
      resultant_width = width
      resultant_height = (img_height * (width / img_width))
    else
      resize_string = "x#{height.to_i}"
      resultant_width = (img_width * (height / img_height))
      resultant_height = height
    end
 
    width_offset, height_offset = crop_offsets_by_gravity(
      gravity,
      [ resultant_width, resultant_height ],
      [ width, height ] )
 
    img.combine_options do |i|
      i.args << '+matte'
      i.resize(resize_string)
      i.gravity('NorthWest')
      i.crop "#{width.to_i}x#{height.to_i}+#{width_offset}+#{height_offset}!"
    end
  end
 
  def crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
    raise(ArgumentError, "Gravity must be one of #{GRAVITY_TYPES.inspect}") unless GRAVITY_TYPES.include?(gravity.to_sym)
    raise(ArgumentError, "Original dimensions must be supplied as a [ width, height ] array") unless original_dimensions.kind_of?(Enumerable) && original_dimensions.size == 2
    raise(ArgumentError, "Cropped dimensions must be supplied as a [ width, height ] array") unless cropped_dimensions.kind_of?(Enumerable) && cropped_dimensions.size == 2
    original_width, original_height = original_dimensions
    cropped_width, cropped_height = cropped_dimensions
    # No vertical offset for northern gravity
    vertical_offset = case gravity
      when :north_west, :north, :north_east then 0
      when :center, :east, :west then [ ((original_height - cropped_height) / 2.0).to_i, 0 ].max
      when :south_west, :south, :south_east then (original_height - cropped_height).to_i
    end
    horizontal_offset = case gravity
      when :north_west, :west, :south_west then 0
      when :center, :north, :south then [ ((original_width - cropped_width) / 2.0).to_i, 0 ].max
      when :north_east, :east, :south_east then (original_width - cropped_width).to_i
    end
    return [ horizontal_offset, vertical_offset ]
  end
end
