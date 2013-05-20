class ImagesController < ApplicationController
  include ContextValidator
  
  before_filter :access_control!

  # GET /images
  # GET /images.json
  def index
    @images = @album.images.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
	end
  end

  # GET /albums/1/images/new
  # GET /albums/1/images/new.json
  def new
	@album = Album.find(params[:album_id])
    @image = Image.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])
	@image.album = @album
	
    respond_to do |format|
      if @image.save
		geo = GeotagInfo.new(params[:geo])
		geo.image = @image
		geo.save
		
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end
  
  def access_control!
    action = params[:action]
	return false unless (action == 'show' || authenticate_user!)
	
	# Get image (if it exists, for non-nested methods)
	@image = params.has_key?(:id) ? Image.find(params[:id]) : nil
	# Get album (if it exists, for nested methods)
	@album = params.has_key?(:album_id) ? Album.find(params[:album_id]) : nil
	
	if !validate_image_permissions(@image, @album, action, current_user.nil? ? nil : current_user.id)
	  permission_denied
	  return false
	else
	  return true
	end
  end
end
