class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :show, :index]
  before_action :authenticate_profile_owner, only: [:edit, :update, :destroy, :show]

  def index
    # Méthode qui récupère tous les utilisateurs et les envoie à la view index (index.html.erb) pour affichage
    @users = User.all
    puts "$" * 60
    puts "Voici le nombre d'utilisateurs dans la base : #{@users.length}"
    puts "$" * 60
  end

  def show
    # Méthode qui récupère l'utilisateur concerné et l'envoie à la view show (show.html.erb) pour affichage
    @user = get_user
  end

  private

  def get_user
    user_id = params[:id].to_i
    puts "$" * 60
    puts "user_id : #{user_id}"
    @user = User.find_by(id: user_id)
    puts "user : #{@user}"
    puts "$" * 60
    @user 
  end

  def authenticate_profile_owner
    @user = get_user
    unless !@user.nil? && @user.id == current_user.id
      flash.notice = "Désolé, mais il ne s'agit pas de votre profil!"
      redirect_back(fallback_location: user_path(current_user.id))
    end
  end
end
