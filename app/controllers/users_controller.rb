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
    @user_hash = get_user_hash
  end

  private

  def get_user_hash
    @user_hash = { "user" => nil, "index" => -1 }
    user_id = params[:id].to_i
    user = nil
    puts "$" * 60
    puts "user_id : #{user_id}"
    nb_total = User.last.id
    if user_id.between?(1, nb_total)
      user = User.find_by(id: user_id)
    end
    @user_hash = { "user" => user, "index" => user_id }
    puts "user_hash : #{@user_hash}"
    puts "$" * 60
    @user_hash 
  end

  def authenticate_profile_owner
    @user_hash = get_user_hash
    unless !@user_hash['user'].nil? && @user_hash['index'] == current_user.id
      flash.notice = "Désolée, mais il ne s'agit pas de votre profil!"
      redirect_back(fallback_location: user_path(current_user.id))
    end
  end
end
