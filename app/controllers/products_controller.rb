class ProductsController < ApplicationController
  def index
    @products = Product.published.default_order
  end

  def show
    @product = Product.find(params[:id])
  end
end
