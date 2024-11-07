class DelegacionsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_delegacion, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[create edit update destroy]

  # GET /delegacions or /delegacions.json
  def index
    @delegacions = current_user.admin? ? Delegacion.all : Delegacion.where(usuario_origen: current_user)
  end

  # GET /delegacions/1 or /delegacions/1.json
  def show
  end

  # GET /delegacions/new
  def new
    @delegacion = Delegacion.new
  end

  # GET /delegacions/1/edit
  def edit
    authorize_delegation_access!
  end

  # POST /delegacions or /delegacions.json
  def create
    @delegacion = Delegacion.new(delegacion_params)
    @delegacion.usuario_origen = current_user # Asocia la delegación al usuario actual

    respond_to do |format|
      if @delegacion.save
        format.html { redirect_to empresa_path(@delegacion.empresa_id), notice: "Delegación creada exitosamente." }
        format.json { render :show, status: :created, location: @delegacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delegacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delegacions/1 or /delegacions/1.json
  def update
    authorize_delegation_access!
    respond_to do |format|
      if @delegacion.update(delegacion_params)
        format.html { redirect_to empresa_path(@delegacion.empresa_id), notice: "Delegación actualizada exitosamente." }
        format.json { render :show, status: :ok, location: @delegacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delegacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delegacions/1 or /delegacions/1.json
  def destroy
    authorize_delegation_access!
    @delegacion.destroy
    respond_to do |format|
      format.html { redirect_to empresa_path(@delegacion.empresa_id), notice: "Delegación eliminada exitosamente.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delegacion
    @delegacion = Delegacion.find(params[:id])
  end

  # Solo permite una lista de parámetros confiables.
  def delegacion_params
    params.require(:delegacion).permit(:empresa_id, :usuario_destino_id, :permisos_delegacion)
  end

  # Verifica que el usuario tenga permisos para crear o editar delegaciones
  def authorize_user!
    unless current_user.admin? || (current_user.id == @delegacion.usuario_origen_id && @delegacion.permisos_delegacion)
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end

  # Verifica que el usuario actual tenga acceso para modificar esta delegación
  def authorize_delegation_access!
    unless current_user.admin? || @delegacion.usuario_origen == current_user
      redirect_to root_path, alert: "No tienes permiso para acceder a esta delegación."
    end
  end
end