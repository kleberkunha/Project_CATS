class ItemsController < ApplicationController
  before_action :is_admin?, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    # Méthode qui récupère tous les photos et les envoie à la view index (index.html.erb) pour affichage
    @items = Item.all
    puts "$" * 60
    puts "Voici le nombre de photos dans la base : #{@items.length}"
    puts "$" * 60
  end

  def show
    # Méthode qui récupère la photo concernée et l'envoie à la view show (show.html.erb) pour affichage
    @item = get_item 
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
    @item = get_item 
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
    @item = get_item 
    if !params[:title].nil? && !params[:price].nil? && !params[:image_url].nil?
      item_saved = @item.update("title" => params[:title], # essaie de sauvegarder en base @item
                                "description" => params[:description],
                                "price" => params[:price],
                                "image_url" => params[:image_url])
      if item_saved
        # si ça a marché, il redirige vers la méthode index
        ok = true
        @item = get_item
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
    @item = get_item 
    if !@item.nil?
      @item.destroy
      redirect_to items_path, status: :ok, notice: 'Ta photo "ratée" a bien été supprimée en base : plus personne ne saura que tu as un jour osé la proposer !'
    end
    puts "$" * 60
  end

  private

  def get_item
    item_id = params[:id].to_i
    puts "$" * 60
    puts "item_id : #{item_id}"
    @item = Item.find_by(id: item_id)
    puts "item : #{@item}"
    puts "$" * 60
    @item
  end

  def is_admin?
    item = get_item
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une vérification du statut de l'utilisateur connecté"
    puts "item : #{@item}"
    puts "admin? : #{current_user.id.to_s == '1'}"
    puts "$" * 60
    unless admin?
      redirect_to items_path, notice: "Vous n'êtes pas l'administrateur du site!"
    end
  end
end
