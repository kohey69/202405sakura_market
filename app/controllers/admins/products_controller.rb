class Admins::ProductsController < Admins::ApplicationController
  before_action :set_product, only: %i[show edit update]

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
      redirect_to admins_root_path, notice: t('controllers.created')
    else
      flash.now[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      respond_to do |format|
        format.html { redirect_to admins_product_path(@product), notice: t('controllers.updated') }
        format.json { head :ok }
      end
    else
      flash.now[:alert] = t('controllers.failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :published, :position, :image)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
