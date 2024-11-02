require 'rqrcode'

class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    generate_qr_code
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Producto creado exitosamente."
    else
      render :new, alert: "Hubo un error al crear el producto."
    end
  end

  def edit
    # Carga del producto realizada en el before_action
  end

  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: "Producto actualizado exitosamente."
    else
      render :edit, alert: "Hubo un error al actualizar el producto."
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Producto eliminado exitosamente."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end

  def generate_qr_code
    qrcode = RQRCode::QRCode.new(product_url(@product))
    @svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6
    )
  end
end
