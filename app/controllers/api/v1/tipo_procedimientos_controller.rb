module Api
  module V1
    class TipoProcedimientosController < ApplicationController
      def index
        render json: {data: TipoProcedimiento.where(visible: true)}, status: :ok
      end

      def create
        begin
          unless current_user.admin?
            raise "No puede crear el tipos de procedimiento"
          end
          # Busco si ya existe
          tp = TipoProcedimiento.find_by_nombre(tipo_procedimiento_params[:nombre])
          unless tp.present?
            tp = TipoProcedimiento.new(tipo_procedimiento_params)
            unless tp.save
              messages = tp.errors.map do |err|
                err.options&.[](:message) || "Error message not available"
              end
              render json: {messages: messages}, status: :unprocessable_entity
            end
          else
            tp.update(visible: true)
          end
          render json: {message: "Tipo de procedimiento creado exitosamente", data: tp}, status: :ok
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :unprocessable_entity
        end
      end

      def destroy
        begin
          unless current_user.admin?
            raise "No puede borrar el tipo de procedimiento"
          end
          tp = TipoProcedimiento.find(params[:id])
          tp.visible = false
          unless tp.save
            messages = tp.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            render json: {messages: messages}, status: :unprocessable_entity
          else
            render json: {message: "Tipo de procedimiento borrado exitosamente"}, status: :ok
          end
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :unprocessable_entity
        end
      end

      private

      def tipo_procedimiento_params
        params.require(:tipo_procedimiento).permit(:nombre)
      end
    end
  end
end