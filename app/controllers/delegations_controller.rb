class DelegationsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_delegation, only: [:apoderar, :completar_apoderamiento]
  
  def index
    @delegations = Delegation.with_email(current_user.email)
  end

  def completar_apoderamiento
    begin
      raise "No puede aceptar esta delegación" unless current_user.email == @delegation.email
      
      if @delegation.apoderado?
        # Obtengo el rol actual si es que tiene
        rol_actual = current_user.roles.where(company_id: @delegation.company_id).first
        
        ActiveRecord::Base.transaction do       
          # Creo la autorizacion guardando el poder para la compañia
          Authorization.create!({
            company_id: @delegation.company_id,
            user_id: current_user.id,
            authorization_file: authorizations_params[:authorization_file]
          })
          
          # Creo o actualizo el rol
          if rol_actual.nil?
            Role.create!({
              user_id: current_user.id, 
              company_id: @delegation.company_id, 
              role: @delegation.role
            })
          else
            rol_actual.update!(role: @delegation.role)
          end
          # Borro la delegacion
          @delegation.destroy!
        end
      end

      redirect_to companies_url
    rescue => e
      redirect_to delegations_url, alert: "No se pudo completar la delegación"
    end
  end

  private

  def set_delegation
    @delegation = Delegation.find(params[:id])
  end

  def delegations_params
    params.require(:delegation).permit(:role)
  end

  def authorizations_params
    params.require(:delegation).require(:authorization).permit(:authorization_file)
  end
end
