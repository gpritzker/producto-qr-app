module Api
  module V1
    class RolesController < ApplicationController
      before_action :set_role, only: [:destroy]

      def destroy
        begin
          # El apoderador puede borrar roles de supervisor y delegado
          # El supervisor puede borrar roles de delegado
          user_rol = current_user.roles.where(company_id: @role.company_id).first
          raise "No puede eliminar este rol" if user_rol.nil?

          if (user_rol.apoderado? && !@role.apoderado?) || (user_rol.supervisor? && @role.delegado?)
            @role.destroy
          else
            raise "No puede eliminar este rol"
          end
          render json: {message: "Rol eliminado exitosamente"}, status: :ok
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :forbidden
        end
      end

      private

      def set_role
        @role = Role.find(params[:id])
        unless @role
          return render json: {message: "No se encontró el rol a procesar"}, status: :not_found
        end
      end

      def role_params
        params.require(:role).permit(:company_id, :user_id)
      end
    end
  end
end
