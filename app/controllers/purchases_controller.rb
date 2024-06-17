class PurchasesController < ApplicationController
  before_action :redirect_if_cart_items_blank, only: %i[new confirm create]

  def index
    @purchases = current_user.purchases.default_order
  end

  def show
  end

  def new
    @purchase = current_user.purchases.build_with_purchase_items
    @purchase.assign_address_attributes(current_user.address)
  end

  def confirm
    @purchase = current_user.purchases.build_with_purchase_items(purchase_params)
    if @purchase.invalid?
      flash[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @purchase = current_user.purchases.build_with_purchase_items(purchase_params)
    if @purchase.save_with_destroy_cart_items
      redirect_to purchases_path, notice: t('controllers.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:address_name, :postal_code, :prefecture, :city, :other_address, :phone_number, :delivery_on, :delivery_time_slot)
  end

  def redirect_if_cart_items_blank
    if current_cart.cart_items.blank?
      redirect_to cart_path, alert: 'カートに商品が入っていません'
    end
  end
end
