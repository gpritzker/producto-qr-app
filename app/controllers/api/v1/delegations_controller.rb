module Api
  module V1
    class DelegationsController < ApplicationController
      before_action :set_delegation, only: [:aceptar, :rechazar]

      def delegar
        begin
          company = Company.find(delegations_params[:company_id])
          raise "No se puede delegar" unless company.present?

          unless current_user.admin?
            role = current_user.roles.where(company_id: company.id)&.first
            raise "No tiene permisos para delegar sobre esta compañia" if role.nil?
          
            if delegations_params[:role].to_i != Role::ROL_APODERADO
              # Si es delegado no puede delegar a un supervisor
              raise "No puede realizar la delegación" if role.role < delegations_params[:role]
            end
          end
          
          # Si el email ingresado es de un usuario existente, verifico que 
          # ya no tenga un rol de mayor jerarquia para la compañia
          # La jerarquia va de APODERADO -> SUPERVISOR -> DELEGADO
          user = User.where(email: delegations_params[:email]).first
          if user.present?
            rol = user.roles.where(company_id: delegations_params[:company_id]).first
            if rol.present?
              raise "El usuario ya tiene rol" if rol.apoderado?
              raise "El usuario ya tiene rol" if rol.delegado? && delegations_params[:role].to_i <= Role::ROL_DELEGADO
              raise "El usuario ya tiene rol" if rol.supervisor? && delegations_params[:role].to_i <= Role::ROL_SUPERVISOR
            end
          end

          Delegation.create!({
            email: delegations_params[:email],
            company_id: company.id,
            role: delegations_params[:role].to_i
          })
          render json: {message: "Delegación creada."}, status: :ok
        rescue ActiveRecord::RecordNotUnique => e
          render json: {message: "Esta delegación fué realizada previamente"}, status: :unprocessable_entity
        rescue ActiveRecord::RecordInvalid => e
          render json: {messages: e.record.errors.full_messages}, status: :unprocessable_entity
        rescue => e
          logger.error e.message
          render json: {messages: e.message}, status: :unprocessable_entity
        end
      end

      def aceptar
        begin
          raise "No puede aceptar esta delegación" unless current_user.email == @delegation.email
          
          ActiveRecord::Base.transaction do
            Role.create!({user_id: current_user.id, company_id: @delegation.company_id, role: @delegation.role})
            @delegation.destroy!
          end
          
          render json: {message: "Delegación aceptada."}, status: :ok
        rescue ActiveRecord::RecordNotUnique => e
          render json: {message: "Esta delegación fué realizada previamente"}, status: :unprocessable_entity
        rescue ActiveRecord::RecordInvalid => e
          render json: {messages: e.record.errors.full_messages}, status: :unprocessable_entity
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :unprocessable_entity
        end
      end

      def rechazar
        begin
          raise "No puede rechazar esta delegación" unless current_user.email == @delegation.email
          @delegation.destroy
          render json: {messages: ["Delegación rechazada."]}, status: :ok
        rescue => e
          logger.error e.message
          render json: {messages: [e.message]}, status: :unprocessable_entity
        end
      end

      private

      def set_delegation
        @delegation = Delegation.find(params[:id])
        unless @delegation
          return render json: {message: "No se encontró la delegación a procesar"}, status: :not_found
        end
      end

      def delegations_params
        params.require(:delegation).permit(:role, :company_id, :email)
      end
    end
  end
end