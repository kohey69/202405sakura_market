class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: %i[show edit update]

  def show
  end

  def new
    @address = current_user.build_address
  end

  def create
    @address = current_user.build_address(address_params)
    if @address.save
      redirect_to address_path, notice: t('controllers.created')
    else
      flash.now[:alert] = t('controllers.failed')
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to address_path, notice: t('controllers.updated')
    else
      flash.now[:alert] = t('controllers.failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_address
    @address = current_user.address
  end

  def address_params
    params.require(:address).permit(:name, :postal_code, :prefecture, :city, :other_address, :phone_number)
  end
end
