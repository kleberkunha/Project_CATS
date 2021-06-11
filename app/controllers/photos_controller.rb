class PhotosController < ApplicationController
  def create
    @item = Item.find(params[:id])
    @item.photo.attach(params[:avatar])
    flash[:success] = "You successfully added your photo"
    redirect_to(user_path(@item))
  end
end
