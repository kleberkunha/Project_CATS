class CartLinesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :show, :index]

  def show
    @cart_line = get_cart_line
  end

  def destroy
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une suppression d'une ligne d'un panier"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "cart_line_id : #{params[:id]}"
    @cart_line = get_cart_line
    if !@cart_line.nil?
      @cart_line.destroy
      redirect_to user_cart_path(@cart_line.cart.user.id, @cart_line.cart.id), status: :ok, notice: 'La photo a bien été supprimée de ton panier !'
    end
    puts "$" * 60
  end

  private

  def get_cart_line
    cart_line_id = params[:id].to_i
    puts "$" * 60
    puts "cart_line_id : #{cart_line_id}"
    @cart_line = CartLine.find_by(id: cart_line_id)
    puts "cart_line : #{@cart_line}"
    puts "$" * 60
    @cart_line
  end
end
