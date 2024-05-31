# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    merge_guest_user_cart!
    session[:cart_id] = nil
    root_path
  end

  private

  def merge_guest_user_cart!
    session_cart = Cart.find(session[:cart_id])
    return if session_cart.blank?

    current_user.cart.transfer_cart_items_from!(session_cart)
  end
end
