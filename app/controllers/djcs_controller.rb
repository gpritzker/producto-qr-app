class DjcsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_djc, only: %i[show edit update destroy]

  # GET /djcs
  def index
    if current_user.admin?
      @djcs = Djc.all
    else
      @djcs = User.djcs_with_role(current_user.id)
    end
  end

  # GET /djcs/:id
  def show
  end

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
      product_attributes: [:marca, :modelo, :cat_tec],
      reports: [:numero, :emisor]
    )
  end
end
