class ApplicationController < ActionController::Base
  helper_method :current_cart

  def current_cart
    if user_signed_in?
      current_user.cart
    elsif session[:cart_id].present?
      Cart.find(session[:cart_id])
    else
      cart = Cart.create!
      session[:cart_id] = cart.id
      cart
    end
  end
end
