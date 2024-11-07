class TipoProcedimientosController < ApplicationController
  before_action :admin_only, except: [:index, :show]
  before_action :set_tipo_procedimiento, only: %i[ show edit update destroy ]

  # GET /tipo_procedimientos or /tipo_procedimientos.json
  def index
    @tipo_procedimientos = TipoProcedimiento.all
  end

  # GET /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def show
  end

  # GET /tipo_procedimientos/new
  def new
    @tipo_procedimiento = TipoProcedimiento.new
  end

  # GET /tipo_procedimientos/1/edit
  def edit
  end

  # POST /tipo_procedimientos or /tipo_procedimientos.json
  def create
    @tipo_procedimiento = TipoProcedimiento.new(tipo_procedimiento_params)

    respond_to do |format|
      if @tipo_procedimiento.save
        format.html { redirect_to @tipo_procedimiento, notice: "Tipo procedimiento was successfully created." }
        format.json { render :show, status: :created, location: @tipo_procedimiento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tipo_procedimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def update
    respond_to do |format|
      if @tipo_procedimiento.update(tipo_procedimiento_params)
        format.html { redirect_to @tipo_procedimiento, notice: "Tipo procedimiento was successfully updated." }
        format.json { render :show, status: :ok, location: @tipo_procedimiento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tipo_procedimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_procedimientos/1 or /tipo_procedimientos/1.json
  def destroy
    @tipo_procedimiento.destroy

    respond_to do |format|
      format.html { redirect_to tipo_procedimientos_path, status: :see_other, notice: "Tipo procedimiento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_procedimiento
      @tipo_procedimiento = TipoProcedimiento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipo_procedimiento_params
      params.require(:tipo_procedimiento).permit(:nombre)
    end
end
