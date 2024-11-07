class DeclaracionConformidadsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_declaracion_conformidad, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    if current_user.admin?
      # Si el usuario es administrador, puede ver todas las declaraciones
      @declaracion_conformidads = DeclaracionConformidad.all
    else
      # Obtener los IDs de las empresas que el usuario tiene acceso (creadas o delegadas)
      empresa_ids = (current_user.empresas.pluck(:id) + current_user.empresas_autorizadas.pluck(:id)).uniq
      
      # Filtrar las declaraciones de conformidad de las empresas accesibles para el usuario
      @declaracion_conformidads = DeclaracionConformidad.joins(:product).where(products: { empresa_id: empresa_ids })
    end
  end

  # GET /declaracion_conformidads/1
  def show
    qr = @declaracion_conformidad.qr
    if qr && qr.url_destino.present?
      @qr_code_svg = RQRCode::QRCode.new(qr.url_destino).as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6
      )
    else
      flash[:alert] = "No se ha generado un código QR para esta declaración."
    end
  end

  # GET /declaracion_conformidads/new
  def new
    @declaracion_conformidad = DeclaracionConformidad.new
    load_supporting_data
  end

  # GET /declaracion_conformidads/1/edit
  def edit
    authorize_user!
    load_supporting_data
  end

  # POST /declaracion_conformidads
  def create
    @declaracion_conformidad = DeclaracionConformidad.new(declaracion_conformidad_params)

    respond_to do |format|
      if @declaracion_conformidad.save
        format.html { redirect_to product_path(@declaracion_conformidad.product_id), notice: "Declaración de conformidad creada exitosamente." }
        format.json { render :show, status: :created, location: @declaracion_conformidad }
      else
        load_supporting_data
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @declaracion_conformidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /declaracion_conformidads/1
  def update
    authorize_user!
    respond_to do |format|
      if @declaracion_conformidad.update(declaracion_conformidad_params)
        format.html { redirect_to product_path(@declaracion_conformidad.producto_id), notice: "Declaración de conformidad actualizada exitosamente." }
        format.json { render :show, status: :ok, location: @declaracion_conformidad }
      else
        load_supporting_data
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @declaracion_conformidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /declaracion_conformidads/1
  def destroy
    authorize_user!
    @declaracion_conformidad.destroy
    respond_to do |format|
      format.html { redirect_to product_path(@declaracion_conformidad.producto_id), status: :see_other, notice: "Declaración de conformidad eliminada exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  # Carga la declaración según el ID
  def set_declaracion_conformidad
    @declaracion_conformidad = DeclaracionConformidad.find(params[:id])
  end

  # Carga datos de apoyo para desplegables en el formulario
  def load_supporting_data
    @productos = current_user.products  # Productos del usuario
    @reglamentos_tecnicos = ReglamentoTecnico.all  # Todos los reglamentos
    @tipos_procedimiento = TipoProcedimiento.all  # Todos los tipos de procedimiento
  end

  # Verifica permisos de usuario para acciones específicas
  def authorize_user!
    unless current_user.admin? || @declaracion_conformidad.producto.user == current_user
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end

  # Lista de parámetros permitidos
  def declaracion_conformidad_params
    params.require(:declaracion_conformidad).permit(:product_id, :reglamento_tecnico_id, :tipo_procedimiento_id, :numero_reporte, :emisor_reporte, :fecha_emision, :estado, :empresa_id, :descripcion_producto, :origen)
  end
end