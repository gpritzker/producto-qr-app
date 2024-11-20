module Api
  module V1
    class DjcsController < ApplicationController
      before_action :set_djc, only: [:sign, :approve]
      before_action :set_role, only: [:sign, :approve]

      # Firma de la DJC
      def sign
        if @role.apoderado? 
          if @djc.update(signed_by: current_user.id, signed_at: Time.current)
            render ApiResponseService::ok(info: "Se firmo exitosamente.")
          else
            render ApiResponseService::error(info: @djc.errors.full_messages, code: :unprocessable_entity)
          end
        else
          render ApiResponseService::error(info: "No puede firmar la declaracion jurada de conformidad", code: :forbidden)
        end
      end

      # Aprueba un DJC
      def approve
        if @role.apoderado? || @role.supervisor?
          if @djc.update(approved_by: current_user.id, approved_at: Time.current)
            render ApiResponseService::ok(info: "Se aprobó exitosamente.")
          else
            render ApiResponseService::error(info: @djc.errors.full_messages, code: :unprocessable_entity)
          end
        else
          render ApiResponseService::error(info: "No puede aprobar la declaracion jurada de conformidad", code: :forbidden)
        end
      end

      private

      def set_djc
        @djc = Djc.find_by(id: params[:id])
        unless @djc
          return render ApiResponseService::error(
            info: "No se encontró la declaracion jurada de conformidad", 
            code: :not_found
          )
        end
      end

      def set_role
        @role = current_user.roles.where(company_id: @djc.company_id).first
        unless @role
          return render ApiResponseService::error(
            info: "No puede modificar la declaracion jurada de conformidad", 
            code: :forbidden
          )
        end
      end
    end
  end
end
