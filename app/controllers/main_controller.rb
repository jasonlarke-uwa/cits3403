class MainController < ApplicationController
  def index
	
  end
  
  def foo
	render :action => :index
  end
end
