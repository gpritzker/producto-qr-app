class EmpresasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_empresa, only: [:show, :edit, :update, :destroy, :delegate]
  before_action :authorize_admin!, only: [:delegate] # Autorizar solo a administradores para ciertas acciones

  def index
    @empresas = current_user.admin? ? Empresa.all : current_user.empresas
    #+ current_user.empresas_delegadas
  end

  def show
    # Mostrar los detalles de la empresa y su lista de productos y declaraciones de conformidad
    @productos = @empresa.products
    @declaraciones = @empresa.declaraciones_conformidad
  end

  def new
    @empresa = Empresa.new
  end

  def create
    # Asocia la empresa al usuario actual como creador
    @empresa = Empresa.new(empresa_params)
    @empresa.admin_user = current_user

    if @empresa.save
      redirect_to @empresa, notice: 'Empresa creada exitosamente.'
    else
      render :new
    end
  end

  def edit
    # Permite solo al creador de la empresa o a un admin editar la empresa
    authorize_admin_or_owner!
  end

  def update
    authorize_admin_or_owner!
    if @empresa.update(empresa_params)
      redirect_to @empresa, notice: 'Empresa actualizada exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    authorize_admin_or_owner!
    @empresa.update(estado: 'suspendido')
    redirect_to empresas_path, notice: 'Empresa suspendida exitosamente.'
  end

  # Acción para delegar la empresa a otro usuario
  def delegate
    @usuario = User.find_by(email: params[:delegate_email])
    if @usuario.present?
      Delegacion.create!(empresa: @empresa, user: @usuario, permisos_delegacion: params[:permisos_delegacion])
      redirect_to @empresa, notice: "Empresa delegada exitosamente a #{@usuario.email}."
    else
      redirect_to @empresa, alert: 'Usuario no encontrado.'
    end
  end

  private

  def set_empresa
    @empresa = Empresa.find(params[:id])
  end

  def empresa_params
    params.require(:empresa).permit(
      :razon_social, :CUIT, :domicilio_legal, :apoderado_nombre,
      :apoderado_CUIL, :apoderado_cargo, :apoderado_contacto
    )
  end

  def authorize_admin!
    redirect_to root_path, alert: 'No tienes permisos para acceder a esta sección.' unless current_user.admin?
  end

  def authorize_admin_or_owner!
    unless current_user.admin? || @empresa.admin_user == current_user
      redirect_to empresas_path, alert: 'No tienes permisos para modificar esta empresa.'
    end
  end
end
