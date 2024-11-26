module Api
  module V1
    class DjcsController < ApplicationController
      before_action :set_djc, only: [:sign, :approve]
      before_action :set_role, only: [:sign, :approve]

      # Firma de la DJC
      def sign
        if @role.apoderado? 
          if @djc.update(signed_by: current_user, signed_at: Time.current)
            render json: {message: "Se firmo exitosamente.", data: @djc}, status: :ok
          else
            messages = @djc.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            return render json: {messages: messages}, status: :unprocessable_entity
          end
        else
          render json: {message: "No puede firmar la declaracion jurada de conformidad"}, status: :forbidden
        end
      end

      # Aprueba un DJC
      def approve
        if @role.apoderado? || @role.supervisor?
          if @djc.update(approved_by: current_user, approved_at: Time.current)
            render json: {message: "Se aprobó exitosamente.", data: @djc}, status: :ok
          else
            messages = @djc.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            return render json: {messages: messages}, status: :unprocessable_entity
          end
        else
          render json: {message: "No puede aprobar la declaracion jurada de conformidad"}, status: :forbidden
        end
      end

      def create
        begin
          @djc = Djc.new(djcs_params)
          @djc.creator = current_user
          unless @djc.save
            messages = @djc.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            return render json: {messages: messages}, status: :unprocessable_entity
          end
          render json: {message: "DJC creada exitosamente", data: @djc}, status: :ok
        rescue => e
          logger.error e.message
          render json: {message: "No se pudo crear la DJC"}, status: :unprocessable_entity
        end
      end

      private

      def set_djc
        @djc = Djc.find(params[:id])
        unless @djc
          return render json: {message: "No se encontró la declaracion jurada de conformidad"}, status: :not_found
        end
      end

      def set_role
        @role = current_user.roles.where(company_id: @djc.company_id).first
        unless @role
          return render json: {message: "No puede modificar la declaracion jurada de conformidad"}, status: :forbidden
        end
      end

      def djcs_params
        params.require(:djc).permit(
          :company_id,
          :qr_id,
          :tipo_procedimiento_id,
          :reglamento_tecnico_id,
          :product_description,
          :deposit_address,
          :manufacturer,
          :origin,
          :trade_mark,
          :manufacturer_address,
          technical_normatives: [],
          product_attributes: [:brand, :model, :characteristic],
          reports: [:number, :emitter]
        )
      end
    end
  end
end
