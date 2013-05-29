class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def req
    user = User.find(params[:id])
    f = Friend.new
    f.initiator = current_user
    f.recipient = user

    f.save
    redirect_to(request.referer)
  end

  def accept
    req
  end

  def remove
    f1 = Friend.where({ :initiator_id => current_user.id, :recipient_id => params[:id] }).first
    f2 = Friend.where({ :initiator_id => params[:id], :recipient_id => current_user.id }).first

    f1.destroy unless f1.nil?
    f2.destroy unless f2.nil?

    redirect_to(request.referer)
  end
end
