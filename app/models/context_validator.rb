module ContextValidator
	def validate_relationship(privacy, owner, viewer)
		case privacy.to_s
		when 'friends'
		  return (viewer.nil? && !authenticate_user!) ? false : Friend.where(:initiator_id => owner, :recipient_id => viewer).exists?
		else
		  # unknown privacy level so reject it, better safe than sorry
		  return false
		end
	end
	
	def validate_album_permissions(album, action, user_id)
		return true if album.nil?
		
		privacy = album.privacy_level.hint
		owner = album.owner.id
		case action.to_s
		when 'show'
			return (privacy == 'public' || owner == user_id) ? true : validate_relationship(privacy, owner, user_id)
		when 'edit', 'update', 'destroy'
			return user_id != nil && owner == user_id
		else
			# for security's sake, just reject any unrecognized actions out of hand
			return false
		end
	end
	
	def validate_image_permissions(image, album, action, user_id)
		case action.to_s
		when 'index'
			return validate_album_permissions(album, 'show', user_id)
		when 'create','new'
			return (album.nil? || !(user_id.nil? || user_id != album.owner.id))
		when 'edit','update','destroy','show'
			return true if image.nil?
			# Use the same logic as with the album permissions to modify an albums images
			return validate_album_permissions(image.album, action, user_id)
		else
			# for security's sake, just reject any unrecognized actions out of hand
			return false
		end
	end
end