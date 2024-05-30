class CartItemsController < ApplicationController
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
    @cart_item = current_cart.cart_items.find_by!(product_id: params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to product_path(@cart_item.product), notice: t('controllers.updated')
    else
      flash[:alert] = t('controllers.failed')
      render 'products/show', status: :unprocessable_entity
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end
end
