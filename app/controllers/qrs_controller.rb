class QrsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_qr, only: %i[show edit update destroy]

  # GET /qrs
  def index
    if current_user.admin?
      @qrs = Qr.all
    else
      @qrs = current_user.qrs
    end
  end

  # GET /qrs/1
  def show
    if @qr.present?
      @qr_code_svg = RQRCode::QRCode.new("http://localhost:3000/d/#{@qr.code}").as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6
      )
    else
      redirect_to qrs_url, alert: "QR inexistente"
    end
  end

  # GET /qrs/new
  def new
    @qr = Qr.new
  end

  # GET /qrs/1/edit
  def edit
  end

  # POST /qrs
  def create
    @qr = Qr.new(qr_params)
    @qr.user = current_user
    respond_to do |format|
      if @qr.save
        format.html { redirect_to qrs_url, notice: "QR creado exitosamente." }
      else
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

  def details
    @qr = Qr.find_by_code(params[:id])
    render layout: nil
  end 

  private

  def set_qr
    @qr = Qr.find(params[:id])
  end

  def authorize_user!
    unless current_user.admin?
      redirect_to qrs_url, alert: "No tienes permiso para realizar esta acción."
    end
  end

  def qr_params
    params.require(:qr).permit(:company_id, :origin, :description, :alias)
  end
end
