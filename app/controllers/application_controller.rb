class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_cart

  def current_cart
    return current_user.cart if user_signed_in?

    Cart.find_by(id: session[:cart_id]) || create_cart_with_session
  end

  private

  def create_cart_with_session
    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end
end
