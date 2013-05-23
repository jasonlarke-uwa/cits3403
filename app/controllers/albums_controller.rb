class AlbumsController < ApplicationController
  include ContextValidator
  
  before_filter :access_control!

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.where(:owner_id => current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
	# all pertinent logic for obtaining the album is done via the access control method
	# and the default view is used, and the only format is html
  end

  # POST /albums
  # POST /albums.json
  def create
	@album = Album.new(params[:album])
	@album.owner = current_user

	respond_to do |format|
		if @album.save
			format.html { redirect_to @album, notice: 'Album was successfully created.' }
			format.json { render json: @album, status: :created, location: @album }
		else
			format.html { render action: "new" }
			format.json { render json: @album.errors, status: :unprocessable_entity }
		end
	end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def access_control!
	action = params[:action]
	return false unless (action == 'show' || authenticate_user!)
	return true if (action == 'new' || action == 'create' || action == 'index')

	@album = Album.find(params[:id]) || record_not_found
	
	if !validate_album_permissions(@album, action, current_user.nil? ? nil : current_user.id)
		permission_denied
		return false
	else
		return true
	end
  end
end
