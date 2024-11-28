class QrsController < ApplicationController
  before_action :authenticate_user!, except: [:details]
  before_action :set_qr, only: %i[show edit update download audit_logs]

  before_action do
    PaperTrail.request.whodunnit = current_user&.id
  end

  # GET /qrs
  def index
    if current_user.admin?
      @qrs = Qr.all.order(id: :desc)
    else
      @qrs = Qr.joins(company: :roles).where(roles: { user_id: current_user.id }).order(id: :desc)
    end
  end

  def audits
    @qrs = Qr.joins(:versions).distinct
  end

  def audit_logs
    @logs = @qr.versions.presence || []
  end

  def show
    # render :qrbig, layout: nil

    # Generar los dos PDFs a partir de las vistas con render_to_string
    pdf_content = render_to_string(
      pdf: @qr.description,         # Nombre del archivo
      template: "qrs/svgs",        # Vista para el PDF
      encoding: "UTF-8",
      locals: { qr: @qr },
      page_height: '50mm',          # Altura personalizada
      page_width: '40mm'            # Ancho personalizado
    )
  
    # Enviar el PDF como archivo descargable
    send_data pdf_content,
              filename: "#{@qr.description.gsub(" ","_")}.pdf", # Nombre del archivo
              type: "application/pdf",
              disposition: "attachment" # Forzar descarga
    
  end

  # GET /qrs/1/edit
  def edit
  end

  # PATCH/PUT /qrs/1
  def update
    if @qr.update(qr_params)
      redirect_to qrs_url, notice: "QR actualizado exitosamente."
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @qr.errors, status: :unprocessable_entity }
    end
  end

  def details
    @qr = Qr.find_by_code(params[:id])
    render layout: nil
  end 

  private

  def set_qr
    @qr = Qr.find(params[:id])
  end

  def qr_params
    params.require(:qr).permit(:company_id, :description)
  end
end
