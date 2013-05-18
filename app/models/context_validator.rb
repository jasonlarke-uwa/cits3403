module ContextValidator
	def validate_relationship(privacy, owner, viewer)
		case privacy.to_s
		when 'friends'
			return Friend.where(:initiator_id => owner, :recipient_id => viewer).exists?
		else
			# unknown privacy level so reject it
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
			return owner == user_id
		end
	end
end