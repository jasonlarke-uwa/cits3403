class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
  
  def permission_denied
	render :file => "public/401.html", :status => :unauthorized, :layout => true
  end
  
  def not_found
	render :file => "public/404.html", :status => :not_found, :layout => true
  end
end
