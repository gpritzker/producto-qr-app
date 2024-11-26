class ReglamentoTecnicosController < ApplicationController
  before_action :authenticate_user!
    
  def index
    @reglamento_tecnicos = ReglamentoTecnico.where(visible: true).order(nombre: :asc)
  end
end
