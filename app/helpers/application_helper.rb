module ApplicationHelper
  def bootstrap_class_for_flash(type)
    case type
      when 'notice' then "alert-info"
      when 'success' then "alert-success"
      when 'error' then "alert-danger"
      when 'alert' then "alert-warning"
    end
  end

  def create_cart_and_assign_to_current_user
    if current_user != nil && current_user.cart == nil
      puts "$" * 60
      puts "Création du panieri pour le user n°#{current_user.id}."
      cart = Cart.create(user: current_user)
      puts "cart : #{cart}"
      puts "$" * 60
    end
  end
end
