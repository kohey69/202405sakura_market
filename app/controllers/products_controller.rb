class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @products = Product.published.default_order
  end

  def show
    @product = Product.published.find(params[:id])
    @cart_item = @product.cart_items.find_or_initialize_by(cart_id: current_cart.id) # cartからcart_itemをbuildするとカートに未保存のcart_itemが金額に加算されるので
  end
end
