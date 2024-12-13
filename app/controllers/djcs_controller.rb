class DjcsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_djc, only: %i[show edit update destroy certificados save_certificados]
  before_action :set_paper_trail_user

  def set_paper_trail_user
    PaperTrail.request.whodunnit = current_user&.id
  end
  
  before_action do
    PaperTrail.request.whodunnit = current_user&.id
  end
  # GET /djcs
  def index
    if current_user.admin?
      @djcs = Djc.all
    else
      @djcs = User.djcs_with_role(current_user.id)
    end
  end

  def audits
    @djcs = Djc.joins(:versions).distinct.order(id: :desc)
  end

  def audit_logs
    @djc = Djc.find(params[:id]) # Esto debe buscar el registro con el ID proporcionado
    @logs = @djc.versions # Obtener las versiones (auditorías) del registro
  end

  # def show
  # #   #### FUNCION PRINCIPAL
  # #   # if @djc.djc_file.attached?
  # #   #   # Descargar el archivo adjunto desde S3
  # #   #   redirect_to rails_blob_url(@djc.djc_file, disposition: "attachment")
  # #   # else
  # #   #   # Si no hay archivo adjunto, manejar el error
  # #   #   logger.warn "Archivo PDF faltante para DJC con ID #{@djc.id} y código #{@djc.qr.code}"
  # #   #   flash[:alert] = "El documento solicitado no está disponible en este momento."
  # #   #   redirect_to djcs_path
  # #   # end
    
  # #   #### IMPRESION VISTA
  # #   # render :show, locals: { djc: @djc }, layout: nil

  # #   #### GENERACION PDF
  #   nombre_temporal = "djc-#{@djc.id}"
  #   nombre_temporal_path = Rails.root.join("tmp", "#{nombre_temporal}.tmp.pdf")
  #   pdf_content = render_to_string(
  #     pdf: nombre_temporal,
  #     template: "djcs/pdf_base",
  #     encoding: "UTF-8",
  #     margin: { top: 10, bottom: 10, left: 10, right: 10 },
  #     locals: { djc: @djc },
  #     page_size: "A4"
  #   )
  #   File.open(nombre_temporal_path, "wb") do |file|
  #     file.write(pdf_content)
  #   end
    
  #   base_pdf_path = Rails.root.join("app", "assets", "base_djc_completa.pdf")
  #   output_pdf_path = Rails.root.join("tmp", "#{nombre_temporal}.pdf")
  #   File.delete(output_pdf_path) if File.exist?(output_pdf_path)
  #   system("hexapdf watermark -w #{base_pdf_path} -i 1 -t background #{nombre_temporal_path} #{output_pdf_path}")
    
  #   pdf_data = File.read(output_pdf_path)
  #   send_data pdf_data, filename: "#{nombre_temporal}.pdf", type: "application/pdf", disposition: "inline"
  # end
  def show
    if @djc.djc_file.attached?
      # Descargar el archivo adjunto desde S3
      redirect_to rails_blob_url(@djc.djc_file, disposition: "attachment")
    else
      # Si no hay archivo adjunto, manejar el error
      logger.warn "Archivo PDF faltante para DJC con ID #{@djc.id} y código #{@djc.qr.code}"
      flash[:alert] = "El documento solicitado no está disponible en este momento."
      redirect_to djcs_path
    end

    # @djc.generate_pdf
    # send_data @djc.djc_file.download,
    #             filename: @djc.djc_file.filename.to_s,
    #             type: @djc.djc_file.content_type,
    #             disposition: 'inline'
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
