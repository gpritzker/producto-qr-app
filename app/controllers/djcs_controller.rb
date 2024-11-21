class DjcsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_djc, only: %i[show edit update destroy pdf]

  # GET /djcs
  def index
    if current_user.admin?
      @djcs = Djc.all
    else
      @djcs = User.djcs_with_role(current_user.id)
    end
  end

  # GET /djcs/:id
  # def show
  #   render layout: nil
  #   respond_to do |format|
  #     format.html # Renderiza la vista normal
  #     format.pdf do
  #       render pdf: "djc-#{@djc.qr.code}-#{@djc.id}", # Nombre del archivo PDF
  #              template: "djcs/show",    # La vista HTML para renderizar
  #              layout: "pdf",            # Opcional: usa un diseño específico para PDF
  #              disposition: 'inline',    # Mostrar en el navegador (puede ser 'attachment' para descarga)
  #              margin: { top: 10, bottom: 10, left: 10, right: 10 },
  #              encoding: "UTF-8"
  #     end
  #   end
  # end
  def show
    send_file(
      Rails.root.join("public", "pdfs", "djc-#{@djc.qr.code}-#{@djc.id}.pdf"), 
      type: 'application/pdf', 
      disposition: 'inline'
    )
  end

  # def pdf
  #   nombre = "djc-#{@djc.qr.code}-#{@djc.id}"
  #   # Generar el PDF como un string binario
  #   pdf_content = render_to_string  pdf: nombre, # Nombre del archivo
  #                                   template: "djcs/show",       # Vista para el PDF
  #                                   encoding: "UTF-8",
  #                                   margin: { top: 10, bottom: 10, left: 10, right: 10 },
  #                                   page_size: "A4" # Usa un tamaño de página estándar
    
  #   # Definir el path donde se guardará el archivo
  #   file_path = Rails.root.join("public", "pdfs", "#{nombre}-tmp.pdf")

  #   # Crear el directorio si no existe
  #   FileUtils.mkdir_p(File.dirname(file_path))

  #   # Guardar el contenido del PDF en un archivo
  #   File.open(file_path, 'ab') do |file|
  #     file.write(pdf_content)
  #   end

  #   watermark_pdf_path = Rails.root.join("public", "pdfs", "watermark.pdf")
  #   main_pdf_path = Rails.root.join("public", "pdfs", "#{nombre}-tmp.pdf")
  #   output_pdf_path = Rails.root.join("public", "pdfs", "#{nombre}.pdf")
  #   system("rm #{output_pdf_path}")
  #   system("hexapdf watermark -w #{watermark_pdf_path} -t stamp #{main_pdf_path} #{output_pdf_path}")
  #   # Uso de la función
  #   send_file(output_pdf_path, type: 'application/pdf', disposition: 'inline')

  #   # send_file("public/pdfs/#{nombre}.pdf", type: 'application/pdf', disposition: 'inline')
  # end

  # GET /djcs/new
  def new
    @djc = Djc.new
  end

  # POST /djcs
  def create
    @djc = Djc.new(djc_params)

    if @djc.save
      redirect_to @djc, notice: 'DJC creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
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
      :legal_address,
      :deposit_address,
      :manufacturer,
      :bussiness_name,
      :trade_mark,
      :manufacturer_address,
      :technical_normatives,
      product_attributes: [:marca, :modelo, :cat_tec],
      reports: [:numero, :emisor]
    )
  end
end
