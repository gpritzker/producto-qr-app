class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role, only: [:destroy]

  def destroy
    # El apoderador puede borrar roles de supervisor y delegado
    # El supervisor puede borrar roles de delegado
    user_rol = current_user.roles.where(company_id: @role.company_id)
    return if user_rol.nil?
    if user_rol.apoderado? && !@role.apoderado?
      @role.destroy
    elsif user_rol.supervisor? && @role.delegado?
      @role.destroy
    end
  end

  private

  def set_qr
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:company_id, :user_id)
  end
end
