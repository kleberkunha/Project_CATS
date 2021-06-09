class CartsController < ApplicationController
  
  before_action :exist?, is_owner, only: [:show, :edit, :destroy]
  
  def show
    @cart = Cart.find(params[:id])
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart=Cart.new(user_id = current_user.id)
    if @cart.save
      flash[:success] = "Cart created"
      redirect_to controller:'carts', action: 'show', id: @cart.id
    else
      render root_path
    end
  end

  private

  def exist?
    if Cart.find(session[:cart_id]).length > 0
      update
    else
      new
  end

  def is_owner
    if Cart.find(session[:cart_id]).id.to_i != params[:id].to_i
      redirect_to "/"
      flash[:warning] = "You cannot see other users' carts!"
    end
  end

end
