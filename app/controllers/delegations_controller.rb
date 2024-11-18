class DelegationsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_delegation, only: [:apoderar, :completar_apoderar, :supervisar]
  before_action :verify_apoderado, only: [:apoderar, :completar_apoderar]

  def index
    @delegations = Delegation.with_email(current_user.email)#.sort(id: :desc)
  end

  def completar_apoderar
    begin
      authorization = Authorization.new
      authorization.company = @delegation.company
      authorization.user = current_user
      authorization.authorization_file = delegations_params[:authorization_file]
      authorization.delegation = @delegation
      authorization.save!
      @delegation.update!(status: :accepted)
    rescue => e
      render :index, alert: "Error al apoderar el usuario."
    else
      redirect_to delegations_url, notice: "Apoderamiento exitoso"
    end

  end

  def supervisar
    @delegation.update!(status: :accepted)
    redirect_to delegations_url, notice: "Supervidor asociado exitosamente"
  end

  private

  def set_delegation
    @delegation = Delegation.find(params[:id])
  end

  def verify_apoderado
    unless current_user.can_by_apoderado? && @delegation.email == current_user.email
      redirect_to delegations_path, alert: "No tienes permisos para acceder a esta sección." 
    end
  end

  def delegations_params
    params.require(:delegation).permit(:authorization_file)
  end
end
