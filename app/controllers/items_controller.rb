class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :is_admin?, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    # Méthode qui récupère tous les photos et les envoie à la view index (index.html.erb) pour affichage
    @items = Item.all
    puts "$" * 60
    puts "Voici le nombre die photos dans la base : #{@items.length}"
    puts "$" * 60
  end

  def show
    # Méthode qui récupère la photo concernée et l'envoie à la view show (show.html.erb) pour affichage
    @item_hash = get_item_hash 
  end

  def new
    # Méthode qui crée une photo vide et l'envoie à une view qui affiche le formulaire pour 'le remplir' (new.html.erb)
    @new_item = Item.new
  end

  def create
    # Méthode qui créé une photo à partir du contenu du formulaire de new.html.erb, soumis par l'utilisateur "admin"
    # pour info, le contenu de ce formulaire sera accessible dans le hash params
    # Une fois la création faite, on redirige généralement vers la méthode show (pour afficher la photo créée)
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une création"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "Trop bien ! Et ceci est ce que l'utilisateur a passé dans le champ title : #{params["title"]}"
    @item = Item.new("title" => params[:title],
                     "description" => params[:description],
                     "price" => params[:price],
                     "image_url" => params[:image_url])
    if @item.save # essaie de sauvegarder en base @item
      # si ça marche, il redirige vers la page d'index du site
      redirect_to items_path, status: :ok, notice: 'Ta superbe photo de chaton(s) a bien été créée en base pour la postérité !'
    else
      # sinon, il render la view new (qui est celle sur laquelle on est déjà)
      render 'new'
    end
    puts "$" * 60
  end

  def edit
    # Méthode qui récupère la photo concernée et l'envoie à la view edit (edit.html.erb) pour affichage dans un formulaire d'édition
    @item_hash = get_item_hash 
  end

  def update
    # Méthode qui met à jour la photo à partir du contenu du formulaire de edit.html.erb, soumis par l'utilisateur "admin"
    # pour info, le contenu de ce formulaire sera accessible dans le hash params
    # Une fois la modification faite, on redirige généralement vers la méthode show (pour afficher la photo modifiée)
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une mise à jour"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "Trop bien ! Et ceci est ce que l'utilisateur a passé dans le champ title : #{params["title"]}"
    ok = false
    @item = Item.find(params[:id])
    @item_hash = { "item" => @item, "index" => params[:id] }
    puts "item_hash : #{@item_hash}"
    if !params[:title].nil? && !params[:price].nil? && !params[:image_url].nil?
      item_saved = @item.update("title" => params[:title], # essaie de sauvegarder en base @item
                                "description" => params[:description],
                                "price" => params[:price],
                                "image_url" => params[:image_url])
      if item_saved
        # si ça a marché, il redirige vers la méthode index
        ok = true
        @item = Item.find(params[:id])
        @item_hash = { "item" => @item, "index" => params[:id] }
        puts "item_hash : #{@item_hash}"
        redirect_to items_path, status: :ok, notice: 'Ta superbe photo de chaton(s) a bien été mise à jour en base : elle est bien plus "attractive" désormais !'
      end
    end
    if !ok
      # sinon, il render la view edit (qui est celle sur laquelle on est déjà)
      render 'edit'
    end
    puts "$" * 60
  end

  def destroy
    # Méthode qui récupère la photo concernée et la détruit en base
    # Une fois la suppression faite, on redirige généralement vers la méthode index (pour afficher la liste à jour)
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une suppression"
    puts "Ceci est le contenu du hash params : #{params}"
    puts "item_id : #{params[:id]}"
    @item_hash = get_item_hash 
    if !@item_hash['item'].nil?
      @item_hash['item'].destroy
      redirect_to items_path, status: :ok, notice: 'Ta photo "ratée" a bien été supprimée en base : plus personne ne saura que tu as un jour osé la proposer !'
    end
    puts "$" * 60
  end

  private

  def get_item_hash
    @item_hash = { "item" => nil, "index" => -1 }
    item_id = params[:id].to_i
    item = nil
    puts "$" * 60
    puts "item_id : #{item_id}"
    nb_total = Item.last.id
    if item_id.between?(1, nb_total)
      item = Item.find_by(id: item_id)
    end
    @item_hash = { "item" => item, "index" => item_id }
    puts "item_hash : #{@item_hash}"
    puts "$" * 60
    @item_hash
  end

  def is_admin?
    picture_id = params[:id].to_i
    picture = nil
    puts "$" * 60
    puts "picture_id : #{picture_id}"
    nb_total = Picture.last.id
    if picture_id.between?(1, nb_total)
      picture = Picture.find_by(id: picture_id)
    end
    unless !picture.nil? && admin?
      redirect_to pictures_path, notice: "Vous n'êtes pas l'administrateur du site!"
    end
    puts "$" * 60
  end
end
