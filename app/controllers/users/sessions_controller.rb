# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super

    return unless user_signed_in?

    guest_user_cart = Cart.find_by(id: session[:cart_id])
    if guest_user_cart.present?
      guest_user_cart.destroy_with_transfer_cart_items_to!(current_user.cart)
    end
    session[:cart_id] = nil
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
