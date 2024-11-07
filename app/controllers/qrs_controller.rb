class QrsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_qr, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy] # Solo administradores o dueños del QR

  # GET /qrs
  def index
    if current_user.admin?
      @qrs = Qr.all
    else
      # Empresas donde el usuario tiene permisos (creadas + autorizadas)
      empresa_ids = (current_user.empresas.pluck(:id) + current_user.empresas_autorizadas.pluck(:id)).uniq
      @qrs = Qr.joins(:declaracion_conformidad).where(declaracion_conformidad: { empresa_id: empresa_ids })
    end
  end

  # GET /qrs/1
  def show
    # Solo mostrar si el usuario tiene acceso
    authorize_user!
  end

  # GET /qrs/new
  def new
    @qr = Qr.new
    load_supporting_data
  end

  # GET /qrs/1/edit
  def edit
    authorize_user!
    load_supporting_data
  end

  # POST /qrs
  def create
    @qr = Qr.new(qr_params)
    @qr.estado = :activo # Asigna el estado por defecto

    respond_to do |format|
      if @qr.save
        format.html { redirect_to @qr, notice: "QR creado exitosamente." }
        format.json { render :show, status: :created, location: @qr }
      else
        load_supporting_data
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @qr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qrs/1
  def update
    authorize_user!
    respond_to do |format|
      if @qr.update(qr_params)
        format.html { redirect_to @qr, notice: "QR actualizado exitosamente." }
        format.json { render :show, status: :ok, location: @qr }
      else
        load_supporting_data
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @qr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qrs/1
  def destroy
    authorize_user!
    @qr.destroy
    respond_to do |format|
      format.html { redirect_to qrs_path, status: :see_other, notice: "QR eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  def set_qr
    @qr = Qr.find(params[:id])
  end

  def load_supporting_data
    @declaraciones_conformidad = current_user.admin? ? DeclaracionConformidad.all : DeclaracionConformidad.where(empresa_id: current_user.empresa_id)
  end

  def authorize_user!
    unless current_user.admin? || @qr.declaracion_conformidad.empresa_id == current_user.empresa_id
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end

  def qr_params
    params.require(:qr).permit(:declaracion_conformidad_id, :estado)
  end
end
