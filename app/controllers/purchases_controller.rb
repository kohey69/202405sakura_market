class PurchasesController < ApplicationController
  before_action :redirect_if_cart_items_blank, only: %i[new confirm create]

  def index
  end

  def show
  end

  def new
    @purchase = current_user.purchases.build
  end

  def confirm
    @purchase = current_user.purchases.build(purchase_params)
    @purchase.assign_cart_attributes(current_cart)
    if @purchase.invalid?
      flash[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @purchase = current_user.purchases.build(purchase_params)
    @purchase.assign_cart_attributes(current_cart)
    @purchase.save_with_purchase_items!
    redirect_to purchases_path, notice: t('controllers.created')
  end

  private

  def purchase_params
    params.require(:purchase).permit(:address_name, :postal_code, :prefecture, :city, :other_address, :phone_number)
  end

  def redirect_if_cart_items_blank
    if current_cart.cart_items.blank?
      redirect_to cart_path, alert: 'カートに商品が入っていません'
    end
  end
end
