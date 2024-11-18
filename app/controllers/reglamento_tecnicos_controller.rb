class ReglamentoTecnicosController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, except: [:index, :show] # Solo usuarios con rol admin pueden acceder
  before_action :set_reglamento_tecnico, only: %i[ show edit update destroy ]

  # GET /reglamento_tecnicos or /reglamento_tecnicos.json
  def index
    @reglamento_tecnicos = ReglamentoTecnico.all
  end

  # GET /reglamento_tecnicos/1 or /reglamento_tecnicos/1.json
  def show
  end

  # GET /reglamento_tecnicos/new
  def new
    @reglamento_tecnico = ReglamentoTecnico.new
  end

  # GET /reglamento_tecnicos/1/edit
  def edit
  end

  # POST /reglamento_tecnicos or /reglamento_tecnicos.json
  def create
    @reglamento_tecnico = ReglamentoTecnico.new(reglamento_tecnico_params)

    respond_to do |format|
      if @reglamento_tecnico.save
        format.html { redirect_to @reglamento_tecnico, notice: "Reglamento tecnico was successfully created." }
        format.json { render :show, status: :created, location: @reglamento_tecnico }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reglamento_tecnico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reglamento_tecnicos/1 or /reglamento_tecnicos/1.json
  def update
    respond_to do |format|
      if @reglamento_tecnico.update(reglamento_tecnico_params)
        format.html { redirect_to @reglamento_tecnico, notice: "Reglamento tecnico was successfully updated." }
        format.json { render :show, status: :ok, location: @reglamento_tecnico }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reglamento_tecnico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reglamento_tecnicos/1 or /reglamento_tecnicos/1.json
  def destroy
    @reglamento_tecnico.destroy

    respond_to do |format|
      format.html { redirect_to reglamento_tecnicos_path, status: :see_other, notice: "Reglamento tecnico was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reglamento_tecnico
    @reglamento_tecnico = ReglamentoTecnico.find(params[:id])
  end

  def admin_only
    redirect_to reglamento_tecnicos_path, alert: "No tienes permisos para acceder a esta sección." unless current_user.admin?
  end

  # Only allow a list of trusted parameters through.
  def reglamento_tecnico_params
    params.require(:reglamento_tecnico).permit(:nombre)
  end
end
