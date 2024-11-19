class QrsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_qr, only: %i[show edit update]

  # GET /qrs
  def index
    if current_user.admin?
      @qrs = Qr.all
    else
      @qrs = Qr.joins(company: :roles).where(roles: { user_id: current_user.id })
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
    params.require(:qr).permit(:company_id, :origin, :description, :alias)
  end
end
