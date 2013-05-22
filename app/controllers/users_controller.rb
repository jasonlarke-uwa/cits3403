class UsersController < ApplicationController
  def albums
    @user = User.find(params[:id])
    unless @user.nil?
      if current_user.nil? || (current_user.id != @user.id && !Friend.where({:initiator_id => @user.id, :recipient_id => current_user.id}).exists?) 
        # Just fetch back the public albums
        @albums = Album.joins(:privacy_level).where(:privacy_levels => {:hint => :public}, :albums => {:owner_id => @user.id})
      else
        # Currently only two types of privacy level so if the currently logged in user is friends jsut give them all access to albums
        @albums = Album.where({:owner_id => @user.id}) 
      end
    end 
    
    respond_to do |format|
      format.html # albums.html.erb
      format.json { render json: @albums }   
    end
  end
end
