require 'rqrcode'

class ProductsController < ApplicationController
  before_action :authenticate_user! # Solo permite acceso a usuarios autenticados
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy] # Solo el dueño o admin puede editar/eliminar

  def index
    # Si el usuario es admin, ve todos los productos; si no, solo los suyos
    @products = current_user.admin? ? Product.all : current_user.products
  end

  def show
    authorize_user! # Asegura que el usuario pueda ver solo sus propios productos
    generate_qr_code
  end

  def new
    @product = Product.new
  end

  def create
    # Asocia el producto al usuario actual al crearlo
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: "Producto creado exitosamente."
    else
      render :new, alert: "Hubo un error al crear el producto."
    end
  end

  def edit
    # Autorización realizada en el `authorize_user!`
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

  def authorize_user!
    # Solo permite acceso si el usuario es el dueño del producto o un administrador
    unless current_user.admin? || @product.user == current_user
      redirect_to products_path, alert: "No tienes permiso para acceder a este producto."
    end
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