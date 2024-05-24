class Admins::ProductsController < Admins::ApplicationController
  def index
    @products = Product.default_order
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admins_products_path, notice: t('controllers.created')
    else
      flash.now[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :published, :position, :image)
  end
end
