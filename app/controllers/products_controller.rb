class ProductsController < ApplicationController
  def index
    @products = Product.published.default_order
  end

  def show
    @product = Product.published.find(params[:id])
    @cart_item = current_cart.cart_items.find_or_initialize_by(product_id: @product.id)
  end
end
