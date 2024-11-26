module Api
  module V1
    class ReglamentoTecnicosController < ApplicationController
      def index
        render json: {data: ReglamentoTecnico.where(visible: true).order(nombre: :asc)}, status: :ok
      end

      def create
        begin
          unless current_user.admin?
            raise "No puede crear el reglamento técnico"
          end
          # Busco si ya existe
          rt = ReglamentoTecnico.find_by_nombre(reglamento_tecnico_params[:nombre])
          unless rt.present?
            rt = ReglamentoTecnico.new(reglamento_tecnico_params)
            unless rt.save
              messages = rt.errors.map do |err|
                err.options&.[](:message) || "Error message not available"
              end
              render json: {messages: messages}, status: :unprocessable_entity
            end
          else
            rt.update(visible: true)
          end
          render json: {message: "Reglamento técnico creado exitosamente", data: rt}, status: :ok
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :unprocessable_entity
        end
      end

      def destroy
        begin
          unless current_user.admin?
            raise "No puede borrar Reglamentos técnicos"
          end
          rt = ReglamentoTecnico.find(params[:id])
          rt.visible = false
          unless rt.save
            messages = rt.errors.map do |err|
              err.options&.[](:message) || "Error message not available"
            end
            render json: {messages: messages}, status: :unprocessable_entity
          else
            render json: {message: "Reglamento técnico borrado exitosamente"}, status: :ok
          end
        rescue => e
          logger.error e.message
          render json: {message: e.message}, status: :unprocessable_entity
        end
      end

      private

      def reglamento_tecnico_params
        params.require(:reglamento_tecnico).permit(:nombre)
      end
    end
  end
end