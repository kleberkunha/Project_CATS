class UserMailer < ApplicationMailer
  default from: ENV['MAILJET_ADRESS']
 
  def welcome_email(user)
    #on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user 

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://monsite.fr/login' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: 'Bienvenue chez nous !') 
  end

  def after_order_email(order)
    @order = order
    @user = @order.user
    mail(to: @user.email, subject: 'Your KittenMarket Order', body: 'something') 
  end

  def admin_confirmation(order)
    @order = order
    mail(to: "anonymous@yopmail.com", subject: 'A new order') 
  end
end
