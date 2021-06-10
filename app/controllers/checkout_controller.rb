class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create
    puts "$" * 60
    puts "Salut, je suis dans le serveur pour une création checkout#create"
    puts "Ceci est le contenu du hash params : #{params}"
    @total = params[:total].to_d
    @stripe_customer = get_stripe_customer
    if !current_user.nil?
      begin
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "Achat d'une ou plusieurs photo(s) de chaton(s)",
            },
            unit_amount: (@total * 100).to_i,
          },
          quantity: 1,
        }],
        mode: 'payment',
        customer: @stripe_customer,
        :customer_email => 
          if @stripe_customer.nil?
            @current_user.email
          end,
        success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url:  checkout_cancel_url,
        locale: "fr",
        payment_intent_data: {
          setup_future_usage: "off_session",
        }
      })
      puts "session : #{@session}"
      respond_to do |format|
        #format.html # renders create.html.erb
        format.js # renders create.js.erb
      end
  
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to user_cart_path(current_user.id, current_user.cart.id), params: {item_id: @item.id}, method: :put 
      end
    end
    puts "$" * 60
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    # si le paiement fonctionne, ce code crée en base une commande
    puts "$" * 60
    puts "Le paiement fonctionne : (checkout#success)"
    puts "session : #{@session}"
    puts "payment_intent : #{@payment_intent}"
    if !@payment_intent.nil?
      order = Order.new(stripe_customer_id: @payment_intent.customer, amount: @payment_intent.amount)
      order.user = current_user
      order.save
      puts "Order : #{order}"

      CartLine.where(:cart_id => current_user.cart.id).delete_all
    end
    puts "$" * 60
  end

  def cancel
    puts "$" * 60
    puts "Le paiement ne fonctionne pas ou a été annulé par l'utilisateur (checkout#cancel)"
    puts "$" * 60
  end

  private

  def get_stripe_customer
    @stripe_customer = nil
    order = Order.where(user_id: current_user.id).last
    puts "$" * 60
    if !order.nil?
      puts "stripe_customer_id : #{order.stripe_customer_id}"
      begin
        @stripe_customer = Stripe::Customer.retrieve order.stripe_customer_id
      rescue Stripe::InvalidRequestError
        # if stripe token is invalid, remove it!
        order.update! stripe_customer_id: nil
        @stripe_customer = nil
      end
    end
    puts "stripe_customer : #{@stripe_customer}"
    puts "$" * 60
    @stripe_customer
  end
end
