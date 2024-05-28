class ProductsController < ApplicationController
  def index
    @products = Product.published.default_order
  end

  def show
    @product = Product.published.find(params[:id])
  end
end
