class PhotosController < ApplicationController
  def create
    @item = Item.find(params[:item_id])
    @item.photo.attach(params[:photo])
    flash[:success] = "You successfully added your photo"
    redirect_to(root_path)
  end
end
