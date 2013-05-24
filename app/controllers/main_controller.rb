class MainController < ApplicationController
  def gallery
	query = PrivacyLevel.select('hint, id')
	levels = {}
	query.map do |record|
		levels[record.hint] = record.id
	end
	
	if current_user.nil?
		@images = Image.joins(:album).where(:albums => { :privacy_level_id => levels['public'] }).order("created_at DESC").limit(100)
	else
		@images = Image.joins(:album).where("(albums.privacy_level_id = ?) OR (albums.privacy_level_id = ? AND (albums.owner_id = ? OR EXISTS(SELECT 1 FROM friends WHERE friends.initiator_id = albums.owner_id AND friends.recipient_id = ?)))", levels['public'], levels['friends'], current_user.id, current_user.id).order("images.created_at DESC").limit(100) 
	end

	respond_to do |format|
		format.html # gallery.html.erb
		format.json { render json: @images }
	end
  end
  
  def people
	@friends = nil

  	unless current_user.nil?
		@friends = Friend.joins("LEFT JOIN users ON users.id = friends.recipient_id").where("friends.initiator_id = ?", current_user.id).select("users.first_name, users.last_name, users.id, EXISTS(SELECT 1 FROM friends AS f WHERE f.initiator_id = friends.recipient_id AND f.recipient_id = friends.initiator_id) AS accepted")
	end

	respond_to do |format|
		format.html # people.html.erb
		format.json { render json: @friends }
	end
  end

  def search
	@search = nil
	@errors = nil

	@model = Search.new(params[:q])
	if model.valid?
		@search = model.run
		render "search"
	else
		@errors = model.errors
		render "people"
	end
  end
end
