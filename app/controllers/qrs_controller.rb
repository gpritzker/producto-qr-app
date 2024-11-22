class QrsController < ApplicationController
  before_action :authenticate_user!, except: [:details]
  before_action :set_qr, only: %i[show edit update download]

  # GET /qrs
  def index
    if current_user.admin?
      @qrs = Qr.all
    else
      @qrs = Qr.joins(company: :roles).where(roles: { user_id: current_user.id })
    end
  end

  def show
    pdf_content = render_to_string(
      pdf: @qr.description, # Nombre del archivo
      template: "qrs/show",       # Vista para el PDF
      encoding: "UTF-8",
      margin: { top: 10, bottom: 10, left: 10, right: 10 },
      locals: { qr: @qr },
      page_size: "A4" # Usa un tamaño de página estándar
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
