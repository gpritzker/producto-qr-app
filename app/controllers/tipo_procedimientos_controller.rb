class TipoProcedimientosController < ApplicationController
  before_action :authenticate_user!

  def index
    @tipo_procedimientos = TipoProcedimiento.where(visible: true).order(nombre: :asc)
  end
end
