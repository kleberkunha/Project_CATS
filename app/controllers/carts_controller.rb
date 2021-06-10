class CartsController < ApplicationController
  
  #before_action :exist?, is_owner, only: [:show, :edit, :destroy]
  
  def show
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour l'affichage du panier de l'utilisateur"
    @cart = Cart.find(params[:id])
    @cart_lines = CartLine.where(:cart_id => params[:id])
    puts "Ceci est le contenu du hash params : #{params}"
    puts "$" * 60
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart = Cart.new(user_id = current_user.id)
    if @cart.save
      flash[:success] = "Cart created"
      redirect_to controller:'carts', action: 'show', id: @cart.id
    else
      render root_path
    end
  end

  def update
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une mise à jour du panier de l'utilisateur"
    puts "Ceci est le contenu du hash params : #{params}"
    ok = false
    if !params[:id].nil? && !params[:item_id].nil?
      cart_line_saved = CartLine.create("cart_id" => params[:id], "item_id" => params[:item_id])
      if cart_line_saved
        ok = true
        redirect_to user_cart_path(current_user.id, params[:id]), status: :ok, notice: 'Cette superbe photo de chaton(s) a bien été ajoutée à ton panier !'
      end
    end
    if !ok
      redirect_to item_path(params[:item_id])
    end
    puts "$" * 60
  end

  def destroy
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une suppression de toutes les lignes d'un panier"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "cart_id : #{params[:id]}"
    @cart_lines = CartLine.where(:cart_id => params[:id])
    if !@cart_lines.nil? && @cart_lines.length > 0
      @cart_lines.length.times do |index|
        @cart_lines[index].destroy
      end
      redirect_to root_path, status: :ok, notice: 'Ton panier a bien été vidé !'
    end
  end

  private

  def exist?
    if Cart.find(session[:cart_id]).length > 0
      update
    else
      render root_path
    end 
  end

  def is_owner
    if Cart.find(session[:cart_id]).id.to_i != params[:id].to_i
      redirect_to "/"
      flash[:warning] = "You cannot see other users' carts!"
    end
  end

end
