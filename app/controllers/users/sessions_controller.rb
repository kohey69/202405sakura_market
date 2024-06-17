# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def create
    super

    return unless user_signed_in?

    guest_user_cart = Cart.find_by(id: session[:cart_id])
    if guest_user_cart.present?
      guest_user_cart.destroy_with_transfer_cart_items_to!(current_user.cart)
    end
    session[:cart_id] = nil
  end

  # protected

  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
