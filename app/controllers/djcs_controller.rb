class DjcsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_djc, only: %i[show edit update destroy certificados save_certificados]

  # GET /djcs
  def index
    if current_user.admin?
      @djcs = Djc.all
    else
      @djcs = User.djcs_with_role(current_user.id)
    end
  end

  def show
    file_path = Rails.root.join("public", "pdfs", "djc-#{@djc.qr.code}-#{@djc.id}.pdf")

    if File.exist?(file_path)
      send_file(
        file_path,
        type: 'application/pdf',
        disposition: 'inline'
      )
    else
      logger.warn "Archivo PDF faltante para DJC con ID #{@djc.id} y código #{@djc.qr.code}"
      flash[:alert] = "El documento solicitado no está disponible en este momento."
      redirect_to djcs_path # Redirecciona al índice de DJCs en la misma pestaña
    end
  end

  # GET /djcs/new
  def new
    @djc = Djc.new
    if params[:company_id].present?
      @company_id = params[:company_id]
    end
    if params[:qr_id].present?
      @qr_id = params[:qr_id]
    end
  end

  # GET /djcs/:id/edit
  def edit
  end

  # PATCH/PUT /djcs/:id
  def update
    if @djc.update(djc_params)
      redirect_to @djc, notice: 'DJC actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def save_certificados
    if @djc.update(djc_params)
      redirect_to djcs_path, notice: 'DJC actualizada exitosamente.'
    else
      render :certificados, status: :unprocessable_entity
    end
  end

  private

  def set_djc
    @djc = Djc.find(params[:id])
  end

  def djc_params
    params.require(:djc).permit(
      :company_id,
      :qr_id,
      :tipo_procedimiento_id,
      :reglamento_tecnico_id,
      :product_description,
      :origin,
      :deposit_address,
      :manufacturer,
      :trade_mark,
      :manufacturer_address,
      technical_normatives: [],
      crs_files: [],
      product_attributes: [:brand, :model, :characteristic],
      reports: [:number, :emitter]
    )
  end
end
