class CartItemsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_product, only: %i[create update]
  before_action :set_cart_item, only: %i[update destroy]

  def create
    @cart_item = current_cart.cart_items.build(cart_item_params)
    if @cart_item.save
      redirect_to product_path(@cart_item.product), notice: t('controllers.created')
    else
      flash[:alert] = t('controllers.failed')
      render 'products/show', status: :unprocessable_entity
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to product_path(@cart_item.product), notice: t('controllers.updated')
    else
      flash[:alert] = t('controllers.failed')
      render 'products/show', status: :unprocessable_entity
    end
  end

  def destroy
    @cart_item.destroy!
    redirect_to product_path(@cart_item.product), notice: t('controllers.destroyed')
  end

  private

  def set_product
    @product = Product.published.find(params[:product_id])
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end
end
